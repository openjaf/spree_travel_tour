module Spree
  class CalculatorTour < BaseCalculator

    def adults_range
      (0..1).to_a
    end

    def children_range
      (0..1).to_a
    end

    def calculate_price(context, product, variant, options)
      return [product.price.to_f] if product.rates.empty?
      # TODO creo que los tours no se calcula la catidad de días de la semana
      # days = context.end_date.to_date - context.start_date.to_date rescue 1

      list = product.rates
      price = []
      list.each do |r|
        if r.start_date <= context.start_date(options).to_s && r.end_date >= context.end_date(options).to_s
          price << {price:(context.adult(options).to_i * r.one_adult.to_i + context.child(options).to_i * r.one_child.to_i), rate:r.id}
        end
      end
      price

      # prices = []
      # days = context.end_date(options).to_date - context.start_date(options).to_date rescue 1
      #
      # list = product.combinations
      # list = list.where('start_date <= ?', context.start_date(options)) if context.start_date(options).present?
      # list = list.where('end_date >= ?', context.end_date(options)) if context.end_date(options).present?
      # list = list.where('adults > ?', 0)
      # list = list.order('price ASC')
      # Log.debug(list.explain)
      # list

      # product.rates.each do |r|
      #   next if context.start_date(options).present? && (context.start_date.to_date < r.start_date.to_date rescue false)
      #   next if context.end_date(options).present? && (context.end_date.to_date > r.end_date.to_date rescue false)
      #   adults_array = get_adult_list(r, context.adult)
      #   children_array = get_child_list(r, context.child)
      #   combinations = adults_array.product(children_array)
      #   combinations.each do |ad, ch|
      #     prices << get_rate_price(r, ad, ch) * days
      #   end
      # end
      # prices
    end

    # def combination_string_for_generation(rate)
    #   ""
    # end
    #
    # def combination_string_for_search(context)
    #   "%"
    # end

    def get_rate_price(rate, adults, children)
      adults = adults.to_i
      children = children.to_i
      price = adults * rate.one_adult.to_i + children * rate.one_child.to_i
      price
    end

    private

    def get_adult_list(rate, pt_adults)
      if pt_adults.present?
        [pt_adults]
      else
        adults_range
      end
    end

    def get_child_list(rate, pt_child)
      if pt_child.present?
        [pt_child]
      else
        children_range
      end
    end


  end
end