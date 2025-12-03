# Product View
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"view","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}],"recommended_by":"dynamic","recommended_code":"3d045e1b39c321ff695604587597231c"}'
 
# Product View with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"view","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}],"recommended_by":"dynamic","recommended_code":"3d045e1b39c321ff695604587597231c","source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# Category View
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"category","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/category/146","category_id":146}'
 
# Category View with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"category","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/category/146","category_id":146,"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'

# Adding a product to the cart
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500","amount":2}],"recommended_by":"dynamic","recommended_code":"3d045e1b39c321ff695604587597231c"}'
 
# Adding a product to the cart with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500","amount":3}],"recommended_by":"dynamic","recommended_code":"3d045e1b39c321ff695604587597231c","source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# Removing a product from the cart
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"remove_from_cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}]}'

# Update the current cart 

# (Example of synchronization of products in the cart)
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/cart","items":[{"id":"100500","quantity":3},{"id":"100123","quantity":1}],"full_cart":true}'
 
# Example of synchronization of products in the cart with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/cart","items":[{"id":"100500","quantity":3},{"id":"100123","quantity":1}],"full_cart":true,"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# (Example of the cart cleaning)
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/cart","full_cart":true}'
 
# Example of the cart cleaning with "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"cart","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/cart","full_cart":true,"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'

# Successful checkout
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"purchase","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/order/success","order_id":"N100500","order_price":750,"order_cash":650,"order_bonuses":100,"order_discount":50,"promocode":"BIRTHDAY","delivery_type":"delivery","payment_type":"cart","items":[{"id":"100500","amount":3,"price":100},{"id":100123,"amount":1,"price":500}]},"custom":{"order_comment":"Delivery after 15:00, 2nd floor, apt. 222","boxes":2,"refund_date":"2021-09-21"}'
 
# Successful checkout with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"purchase","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/order/success","order_id":"N100500","order_price":750,"order_cash":650,"order_bonuses":100,"order_discount":50,"promocode":"BIRTHDAY","delivery_type":"delivery","payment_type":"cart","items":[{"id":"100500","amount":3,"price":100},{"id":100123,"amount":1,"price":500}],"custom":{"order_comment":"Delivery after 15:00, 2nd floor, apt. 222","boxes":2,"refund_date":"2021-09-21"},"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# Search Request
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"search","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/search","search_query":"apple","recommended_code":"apple"}'
 
# Search Request with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"search","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/search","search_query":"apple","recommended_code":"apple","source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# Adding a product to the wishlist
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"wish","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}]}'
 
# Adding a product to the wishlist with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"wish","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}],"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# Removing a product from the wishlist
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"remove_wish","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"android","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}]}'
 
# Removing a product from the wishlist with the "source" param
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"remove_wish","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/product/100500","items":[{"id":"100500"}],"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'
  
# Update the current wishlist

# (Example of synchronization of products in the wishlist)
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"wish","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"ios","segment":"A","referer":"https://mystore.com/wish","items":[{"id":"100500"},{"id":"100123"}],"full_wish":true}'

# (Example of the wishlist cleaning)
curl 'https://api.personaclick.com/push' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event":"wish","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/wish","full_wish":true}'

# Custom Event
curl 'https://api.personaclick.com/push/custom' \
  -X 'POST' \
  -H 'content-type: application/json' \
  -d '{"event": "my_event","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance": "R5eQXkrKCf","stream": "web","segment": "A","referer": "https://mystore.com/product/100500","category": "my_category","label": "my_label","value": 100500,"payload": {"string_value": "my_string","int_value": 100500,"float_value": 5.45,"date_value": "2021-03-24","bool_value": false}}'

# Custom Event with the "source" param
curl 'https://api.personaclick.com/push/custom' \
  -X 'POST' \
  -H 'content-type: application/json \
  -d '{"event":"my_event","shop_id":"0d42fd8b713d0752776ca589cc0056","did":"7rjVGhMykT","seance":"R5eQXkrKCf","stream":"web","segment":"A","referer":"https://mystore.com/product/100500","category":"my_category","label":"my_label","value":100500,"source":"{\"from\":\"chain\",\"code\":\"abcdef-0123-4567-9810-012345abcdef\"}"}'