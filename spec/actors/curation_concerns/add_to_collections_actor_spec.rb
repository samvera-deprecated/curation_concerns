require 'spec_helper'
describe CurationConcerns::Actors::AddToCollectionActor do
  let(:user) { create(:user) }
  let(:curation_concern) { GenericWork.new }
  let(:attributes) { {} }
  let(:collection) { create(:collection).tap do |col|
    col.apply_depositor_metadata user
  end }
  subject do
    CurationConcerns::Actors::ActorStack.new(curation_concern,
                                             user,
                                             [described_class,
                                              CurationConcerns::Actors::GenericWorkActor])
  end
  describe 'the next actor' do
    let(:root_actor) { double }
    before do
      allow(CurationConcerns::Actors::RootActor).to receive(:new).and_return(root_actor)
    end

    let(:attributes) do
      { collection_ids: ['123'], title: ['test'] }
    end

    it 'does not receive the collection_ids' do
      expect(root_actor).to receive(:create).with(title: ['test'])
      subject.create(attributes)
    end
  end

  describe 'create' do
    let(:attributes) do
      { collection_ids: [collection.id], title: ['test'] }
    end

    it 'adds it to the collection' do
      expect(subject.create(attributes)).to be true
      expect(collection.reload.members).to eq [curation_concern]
    end

    describe "when work is in user's own collection" do
      it "removes the work from that collection" do
        # had to move collection and subject down into the spec to ensure they use the same user
        collection = create(:collection).tap do |col|
          col.apply_depositor_metadata user
        end
        subject.create(attributes)
        expect(subject.create(collection_ids: [])).to be true
        expect(collection.reload.members).to eq []
      end
    end

    describe "when work is in another user's collection" do
      let(:other_user) { create(:user) }
      before do
        collection.apply_depositor_metadata other_user
        subject.create(attributes)
      end

      it "doesn't remove the work from that collection" do
        expect(subject.create(collection_ids: [])).to be true
        expect(collection.reload.members).to eq [curation_concern]
      end
    end
  end
end
