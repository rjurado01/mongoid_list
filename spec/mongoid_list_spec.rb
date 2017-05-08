require 'spec_helper'

RSpec.describe MongoidList do
  it 'has a version number' do
    expect(MongoidList::VERSION).not_to be nil
  end

  context 'when scope is not defined' do
    before do
      @items = Array.new(4) { Parent.create }
    end

    context 'when new document is created' do
      it 'initializes position field correctly' do
        (0..3).each do |index|
          expect(@items[index].reload.position).to eq(index + 1)
          expect(@items[index].reload.position).to eq(index + 1)
        end
      end
    end

    context 'when document is removed' do
      it 'updates other elements position' do
        @items[0].destroy
        expect(@items[1].reload.position).to eq(1)
        expect(@items[2].reload.position).to eq(2)
        expect(@items[3].reload.position).to eq(3)
      end
    end

    context 'when document position is decreased to first' do
      it 'updates other elements position' do
        @items[3].position = 1
        @items[3].save

        expect(@items[3].reload.position).to eq(1)
        expect(@items[0].reload.position).to eq(2)
        expect(@items[1].reload.position).to eq(3)
        expect(@items[2].reload.position).to eq(4)
      end
    end

    context 'when document position is setted to intermediate' do
      it 'updates other elements position' do
        @items[1].position = 3
        @items[1].save

        expect(@items[0].reload.position).to eq(1)
        expect(@items[2].reload.position).to eq(2)
        expect(@items[1].reload.position).to eq(3)
        expect(@items[3].reload.position).to eq(4)
      end
    end

    context 'when document position is increased to last' do
      it 'updates other elements position' do
        @items[0].position = 4
        @items[0].save

        expect(@items[1].reload.position).to eq(1)
        expect(@items[2].reload.position).to eq(2)
        expect(@items[3].reload.position).to eq(3)
        expect(@items[0].reload.position).to eq(4)
      end
    end
  end

  context 'when scope is defined' do
    before do
      @parent1 = Parent.create
      @parent2 = Parent.create
      @parent1_childs = Array.new(4) { Child.create(parent: @parent1) }
      @parent2_childs = Array.new(4) { Child.create(parent: @parent2) }
    end

    it 'initializes position field correctly' do
      (0..3).each do |index|
        expect(@parent1_childs[index].reload.position).to eq(index + 1)
        expect(@parent2_childs[index].reload.position).to eq(index + 1)
      end
    end

    context 'when document is removed' do
      it 'updates other elements position' do
        @parent1_childs[0].destroy
        expect(@parent1_childs[1].reload.position).to eq(1)
        expect(@parent1_childs[2].reload.position).to eq(2)
        expect(@parent1_childs[3].reload.position).to eq(3)
      end
    end

    context 'when document position is decreased to first' do
      it 'updates other elements position' do
        @parent1_childs[3].position = 1
        @parent1_childs[3].save

        expect(@parent1_childs[3].reload.position).to eq(1)
        expect(@parent1_childs[0].reload.position).to eq(2)
        expect(@parent1_childs[1].reload.position).to eq(3)
        expect(@parent1_childs[2].reload.position).to eq(4)
      end
    end

    context 'when document position is setted to intermediate' do
      it 'updates other elements position' do
        @parent1_childs[1].position = 3
        @parent1_childs[1].save

        expect(@parent1_childs[0].reload.position).to eq(1)
        expect(@parent1_childs[2].reload.position).to eq(2)
        expect(@parent1_childs[1].reload.position).to eq(3)
        expect(@parent1_childs[3].reload.position).to eq(4)
      end
    end

    context 'when document position is increased to last' do
      it 'updates other elements position' do
        @parent1_childs[0].position = 4
        @parent1_childs[0].save

        expect(@parent1_childs[1].reload.position).to eq(1)
        expect(@parent1_childs[2].reload.position).to eq(2)
        expect(@parent1_childs[3].reload.position).to eq(3)
        expect(@parent1_childs[0].reload.position).to eq(4)
      end
    end
  end
end
