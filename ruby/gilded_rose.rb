class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
        if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
          reduction = check_reduction_value(item)
          decrease_quality(item, reduction)
        else
          increase_quality(item)
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            update_backstage_pass(item)
          end
        end
      end
    end
  end

  def update_backstage_pass(item)
    if item.sell_in < 11
      increase_quality(item)
    end
    if item.sell_in < 6
      increase_quality(item)
    end
    if item.sell_in < 0
      item.quality = 0
    end
  end

  def increase_quality(item)
    if item.quality < 50
      item.quality = item.quality + 1
    end
  end

  def decrease_quality(item, reduction)
    if item.quality > 0
      item.quality -= reduction
    end
    if item.quality < 0
      item.quality = 0
    end
  end

  def check_reduction_value(item)
    if item.sell_in < 0
      reduction = 2
    else
      reduction = 1
    end
    if is_conjured_item(item)
      reduction = reduction * 2
    end
    reduction
  end

  def is_conjured_item(item)
    [item.name.downcase].grep(/conjured/).any?
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end