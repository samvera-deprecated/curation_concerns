require 'spec_helper'

describe CurationConcerns::CreateDerivativesService do
  before do
    @ffmpeg_enabled = CurationConcerns.config.enable_ffmpeg
    CurationConcerns.config.enable_ffmpeg = true
    @generic_file = GenericFile.create { |gf| gf.apply_depositor_metadata('jcoyne@example.com') }
  end

  after do
    CurationConcerns.config.enable_ffmpeg = @ffmpeg_enabled
  end

  describe 'thumbnail generation' do
    before do
      Hydra::Works::AddFileToGenericFile.call(@generic_file, File.join(fixture_path, file_name), :original_file)
      allow_any_instance_of(GenericFile).to receive(:mime_type).and_return(mime_type)
      @generic_file.save!
    end
    context 'with a video (.avi) file', unless: $in_travis do
      let(:mime_type) { 'video/avi' }
      let(:file_name) { 'countdown.avi' }

      it 'lacks a thumbnail' do
        expect(@generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail on job run' do
        described_class.run(@generic_file)
        expect(@generic_file.thumbnail).to have_content
        expect(@generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end

    context 'with an audio (.wav) file', unless: $in_travis do
      let(:mime_type) { 'audio/wav' }
      let(:file_name) { 'piano_note.wav' }

      it 'lacks a thumbnail' do
        expect(@generic_file.thumbnail).to be_nil
      end

      it 'does not generate a thumbnail on job run' do
        described_class.run(@generic_file)
        expect(@generic_file.thumbnail).not_to have_content
      end
    end

    context 'with an image (.jp2) file' do
      let(:mime_type) { 'image/jp2' }
      let(:file_name) { 'image.jp2' }

      it 'lacks a thumbnail' do
        expect(@generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail on job run' do
        described_class.run(@generic_file)
        expect(@generic_file.thumbnail).to have_content
        expect(@generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end

    context 'with an office document (.docx) file', unless: $in_travis do
      let(:mime_type) { 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' }
      let(:file_name) { 'charter.docx' }

      it 'lacks a thumbnail' do
        expect(@generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail on job run' do
        described_class.run(@generic_file)
        expect(@generic_file.thumbnail).to have_content
        expect(@generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end
  end

  describe 'audiovisual transcoding' do
    before do
      Hydra::Works::AddFileToGenericFile.call(@generic_file, File.join(fixture_path, file_name), :original_file)
      allow_any_instance_of(GenericFile).to receive(:mime_type).and_return(mime_type)
      @generic_file.transform_file :original_file, { mp4: { format: 'mp4' }, webm: { format: 'webm'}, thumbnail: { format: 'jpg', datastream: 'thumbnail' } }, processor: :video #, output_file_service: Hydra::Works::PersistDerivative
      @generic_file.save!
    end
    context 'with a video (.avi) file', unless: $in_travis do
      let(:mime_type) { 'video/avi' }
      let(:file_name) { 'countdown.avi' }
      let(:destination_name)    { File.join(fixture_path, file_name) }
      let(:service_type)        { ::RDF::URI("http://pcdm.org/use#ServiceFile") }
      let(:file)                { File.new(destination_name) }

      it 'transcodes to webm and mp4' do
        #pending "Blocked by https://github.com/projecthydra/hydra-derivatives/issues/60"
        described_class.run(@generic_file)
        #@generic_file.save!
        derivative = @generic_file.attached_files['webm']
        expect(derivative).not_to be_nil
        expect(derivative.content).not_to be_nil
        expect(derivative.mime_type).to eq('video/webm')

        derivative2 = @generic_file.attached_files['mp4']
        expect(derivative2).not_to be_nil
        expect(derivative2.content).not_to be_nil
        expect(derivative2.mime_type).to eq('video/mp4')
      end
    end

    context 'with an audio (.wav) file', unless: $in_travis do
      let(:mime_type) { 'audio/wav' }
      let(:file_name) { 'piano_note.wav' }

      it 'transcodes to mp3 and ogg' do
        #pending "Blocked by https://github.com/projecthydra/hydra-derivatives/issues/60"
        described_class.run(@generic_file)
        derivative = @generic_file.attached_files['mp3']
        expect(derivative).not_to be_nil
        expect(derivative.content).not_to be_nil
        expect(derivative.mime_type).to eq('audio/mpeg')

        derivative2 = @generic_file.attached_files['ogg']
        expect(derivative2).not_to be_nil
        expect(derivative2.content).not_to be_nil
        expect(derivative2.mime_type).to eq('audio/ogg')
      end
    end

    context 'with an mp3 file' do
      let(:mime_type) { 'audio/mpeg' }
      let(:file_name) { 'test5.mp3' }
      #Need a way to do this in hydra-derivatives
      it 'should copy the content to the mp3 datastream and transcode to ogg' do
        described_class.run(@generic_file)
        derivative = @generic_file.attached_files['mp3']
        expect(derivative.content.size).to eq(@generic_file.original_file.content.size)
        expect(derivative.mime_type).to eq('audio/mpeg')

        derivative2 = @generic_file.attached_files['ogg']
        expect(derivative2.content).not_to be_nil
        expect(derivative2.mime_type).to eq('audio/ogg')
      end
    end

    context 'with an ogg file' do
      let(:mime_type) { 'audio/ogg' }
      let(:file_name) { 'Example.ogg' }

      #Need a way to do this in hydra-derivatives
      it 'should copy the content to the ogg datastream and transcode to mp3' do
        described_class.run(@generic_file)
        derivative = @generic_file.attached_files['mp3']
        expect(derivative).not_to be_nil
        expect(derivative.content).not_to be_nil
        expect(derivative.mimeType).to eq('audio/mpeg')

        derivative2 = @generic_file.attached_files['ogg']
        expect(derivative2).not_to be_nil
        expect(derivative2.content.size).to eq(@generic_file.original_file.content.size)
        expect(derivative2.mime_type).to eq('audio/ogg')
      end
    end
  end
end
