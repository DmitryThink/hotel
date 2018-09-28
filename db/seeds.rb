# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?


Room.first.update!(description: "Стандартный трёхместный номер.")
Room.second.update!(description: "Люкс 4-местный.")
Item.create!(room_id: 1, name: "Двойная кровать")
Item.create!(room_id: 2, name: "Двойная кровать")
Item.create!(room_id: 1, name: "Диван")
Item.create!(room_id: 2, name: "Диван двухместный или диван и кровать одноместные")
Item.create!(room_id: 1, name: "Душ")
Item.create!(room_id: 2, name: "Душ")
Item.create!(room_id: 1, name: "Бесплатный Wi-Fi")
Item.create!(room_id: 2, name: "Бесплатный Wi-Fi")
Item.create!(room_id: 1, name: "Телевизор")
Item.create!(room_id: 2, name: "Телевизор")
Item.create!(room_id: 1, name: "Кондиционер в номере")
Item.create!(room_id: 2, name: "Кондиционер в номере")
Item.create!(room_id: 1, name: "Чайник")
Item.create!(room_id: 2, name: "Чайник")
Item.create!(room_id: 1, name: "Полотенца, бельё и т.д.")
Item.create!(room_id: 2, name: "Полотенца, бельё и т.д.")