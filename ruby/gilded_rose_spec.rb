require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "does not change the quality of Sulfuras, Hand of Ragnaros" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 80
    end

    it "does not change the sell in value of Sulfuras, Hand of Ragnaros" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 0
    end

    it "will decrease the quality of an item by 1 before the sell in has passed" do
      items = [Item.new("other item", 10, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 49
      expect(items[0].sell_in).to eq 9
    end

    it "will decrease the quality of an item by 2 after the sell in has passed" do
      items = [Item.new("other item", 0, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 48
      expect(items[0].sell_in).to eq -1
    end

    it "will not decrease the quality of an item below 0" do
      items = [Item.new("other item", 0, 1)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
      expect(items[0].sell_in).to eq -1
    end

    it "will increase the quality of aged brie" do
      items = [Item.new("Aged Brie", 2, 40)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 41
      expect(items[0].sell_in).to eq 1
    end

    it "will not increase the quality of aged brie to more than 50" do
      items = [Item.new("Aged Brie", 2, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
    end
  end

  describe "backstage passes" do
    it "will increase the quality by 1 when the sell in is greater than 10" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 11
    end

    it "will increase the quality by 2 when the sell in is between 10 and 6" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 8, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 12
    end

    it "will increase the quality by 3 when the sell in is between 5 and 0" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 13
    end

    it "will not increase the quality to greater than 50" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 49)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
    end

    it "will decrese the quality to 0 when the sell in is 0 or less" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end
  end

  describe "conjured items" do
    it "will identify conjured items based on name" do
      items = [Item.new("conjured item", 10, 50),Item.new("other item", 0, 1) ]
      conjured = GildedRose.new(items).is_conjured_item(items[0])
      not_conjured = GildedRose.new(items).is_conjured_item(items[1])
      expect(conjured).to eq true
      expect(not_conjured).to eq false
    end

    it "will identify conjured items based on name (case insensitive" do
      items = [Item.new("Conjured item", 10, 50), Item.new("other item", 0, 1)]
      conjured = GildedRose.new(items).is_conjured_item(items[0])
      not_conjured = GildedRose.new(items).is_conjured_item(items[1])
      expect(conjured).to eq true
      expect(not_conjured).to eq false
    end

    it "will decrease the quality of a conjured item by 2 before the sell in has passed" do
      items = [Item.new("conjured item", 10, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 48
      expect(items[0].sell_in).to eq 9
    end

    it "will decrease the quality of a conjured item by 4 after the sell in has passed" do
      items = [Item.new("conjured item", 0, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 46
      expect(items[0].sell_in).to eq -1
    end

    it "will not decrease the quality of a conjured item below 0 " do
      items = [Item.new("conjured item", 10, 1)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
      expect(items[0].sell_in).to eq 9
    end
  end
end
