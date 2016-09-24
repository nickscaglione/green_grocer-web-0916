def consolidate_cart(cart)
  new_cart_hash = {}
  cart.each do |single_item_hash|
    single_item_hash.each do |item, price_clear_hash|
      if !new_cart_hash.keys.include?(item)
        new_cart_hash[item] = price_clear_hash
        new_cart_hash[item][:count] = 1
      else
        new_cart_hash[item][:count] += 1
      end
    end
  end
  new_cart_hash
end

def apply_coupons(cart, coupons)
  couponed_hash = cart
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item]) && !couponed_hash.keys.include?("#{coupon[:item]}" + " W/COUPON") && couponed_hash[coupon[:item]][:count] >= coupon[:num]
      couponed_hash["#{coupon[:item]}" + " W/COUPON"] = {
        :price => coupon[:cost],
        :clearance => cart[coupon[:item]][:clearance],
        :count => 1
      }
      couponed_hash[coupon[:item]][:count] -= coupon[:num]
    elsif couponed_hash.keys.include?("#{coupon[:item]}" + " W/COUPON") &&  couponed_hash[coupon[:item]][:count] >= coupon[:num]
      couponed_hash[coupon[:item]][:count] -= coupon[:num]
      couponed_hash["#{coupon[:item]}" + " W/COUPON"][:count] += 1
    end
  end
  couponed_hash
end

def apply_clearance(cart)
  cart.each do |item, price_clear_count_hash|
    if price_clear_count_hash[:clearance]
      price_clear_count_hash[:price] = (price_clear_count_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, price_clear_count_hash|
    total += price_clear_count_hash[:price] * price_clear_count_hash[:count]
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
