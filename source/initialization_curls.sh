# For the first request for the Device ID and User Session ID
curl https://api.personaclick.com/init?shop_id=0d42fd8b713d0752776ca589cc0056

# To update a user's Session ID
curl https://api.personaclick.com/init?shop_id=0d42fd8b713d0752776ca589cc0056&did=7rjVGhMykT

# Full example when all IDs have already been received
curl https://api.personaclick.com/init?did=7rjVGhMykT&shop_id=0d42fd8b713d0752776ca589cc0056&referer=https%3A%2F%2Fmystore.com%2F&seance=R5eQXkrKCf&tz=3&testmode=true