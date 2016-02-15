class MakeBeerStylesASeparateTable < ActiveRecord::Migration
  def change
      rename_column :beers, :style, :old_style
      add_column :beers, :style_id, :integer

      Beer.reset_column_information

      create_table :styles do |t|
          t.text :style
          t.text :description

          t.timestamps null: false
      end

      beer_styles = Beer.all.map{ |b| b.old_style }.uniq

      beer_styles.each do |style|
          Style.create style: style
      end

      beers = Beer.all

      beers.each do |beer|
          beer.style = Style.find_by(style: beer.old_style)

          if beer.style.nil?
              beer.style = Style.first
          end

          beer.save!
      end

      remove_column :beers, :old_style, :string
  end
end
