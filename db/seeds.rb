Booking.destroy_all
Visit.destroy_all
Work.destroy_all
User.destroy_all

#checking errors in seeds



#this is admin only
# this shows how the site works for just an administrator
user1 = User.create(
  :password => "admin12345",
  :user_name => "admin_cool",
  :email => "admin@example.com",
  :name => "Admin Stroganoff",
  :profile_image => "",
  :location => "Newtown",
  :latitude => "",
  :longitude => "",
  :phone => "05-38-37-75",
  :is_artist => false,
  :blurb => "Lorem ipsum dolor sit amet, consectetur adipisicing elit",
  :is_admin => true)

# this user is admin and artist at the same time
# they have 5 works they have added
# we use this user to show what a gallery with lots of work looks like
user2 = User.create(
  :password => "chicken12345",
  :user_name => "great-artist",
  :email => "tatoo_king@example.com",
  :name => "Harrison Ford",
  :profile_image => "https://images.unsplash.com/photo-1485742032238-7543513eeba6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=fcb9b99a534c70a94cf558bd07d3bffd&auto=format&fit=crop&w=1500&q=80",
  :location => "Newtown",
  :latitude => -33.899337,
  :longitude => 151.178607,
  :phone => "234-657-343",
  :is_artist => true,
  :blurb => "First-rate tattos on demand",
  :is_admin => true)

# this is artist only
# they are new and haven't uploaded anything
# we use this user to show what any empty gallery will look like
user3 = User.create(
  :password => "dog12345",
  :user_name => "simple_artist",
  :email => "simple_pleasures@example.com",
  :name => "John Travolta",
  :profile_image => "https://images.unsplash.com/photo-1519262113844-152510a1d98a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=11972b5dd562c360eeb4941abd19ca2e&auto=format&fit=crop&w=634&q=80",
  :location => "Double Bay",
  :latitude => -33.8775,
  :longitude => 151.2411111111,
  :phone => "455-666-777",
  :is_artist => true,
  :blurb => "Simple Clean tattoo designs",
  :is_admin => false)

# this is customer with booking already seeded
# we use this user so we can test what it looks like for a user
# with an upcoming booking
user4 = User.create(
  :password => "cat12345",
  :user_name => "johny_boy",
  :email => "john555@example.com",
  :name => "John Ruski",
  :profile_image => "https://images.unsplash.com/photo-1504376626428-15e04b55193b?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c9e625c1dce077cc441f3f79d26dc583&auto=format&fit=crop&w=1050&q=80",
  :location => "Liverpool",
  :latitude => -33.919358,
  :longitude => 150.919605,
  :phone => "345-6765-3654",
  :is_artist => false,
  :blurb => "Want to get my first tatoo!",
  :is_admin => false)

# this is customer with nothing booked yet
# we use this to show a user who has just signed up
user5 = User.create(
  :password => "lizard12345",
  :user_name => "lizzie_girl",
  :email => "lizzie_smith@example.com",
  :name => "Lizzie Vanilla",
  :profile_image => "https://images.unsplash.com/photo-1520872024865-3ff2805d8bb3?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=0237069e47289314d9d9adb227a3fd7b&auto=format&fit=crop&w=821&q=80",
  :location => "Darlinghurst",
  :latitude => -33.876843,
  :longitude => 151.218442,
  :phone => "454-646-356",
  :is_artist => false,
  :blurb => "Would love a custom-made tattoo for a reasonable price",
  :is_admin => false)

  if user5.errors.any?

      user5.errors.full_messages.each do |msg|
         p msg
      end
    end
# Below we seed 5 works, then link them to user2

work1 = Work.create(
:title => "Yakuza",
:price => 20.99,
:artwork_image => "https://images.unsplash.com/photo-1454329030972-00583f5f051f?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e4fb9504f8af7a8c7660114413df03d9&auto=format&fit=crop&w=1042&q=80",
:category => "black-and-white")
user2.works << work1

work2 = Work.create(
:title => "Death",
:price => 55.49,
:artwork_image => "https://images.unsplash.com/photo-1475868530036-7e1f42b9c91c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=9e3ebce528cd9c8550bea0bcf02e3542&auto=format&fit=crop&w=992&q=80",
:category => "colour ink")
user2.works << work2

work3 = Work.create(
:title => "Positive",
:price => 19.99,
:artwork_image => "https://images.unsplash.com/photo-1517613014533-70f3817be7e5?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed7934915cbbb8a845920e5eb318b774&auto=format&fit=crop&w=700&q=80",
:category => "colour splash")
user2.works << work3

work4 = Work.create(
:title => "Mirror",
:price => 125.99,
:artwork_image => "https://images.unsplash.com/photo-1498326458300-02cceca23326?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=1d65d8135e4d6b11a38ef2c391c276b9&auto=format&fit=crop&w=1050&q=80",
:category => "thick brushes")
user2.works << work4

work5 = Work.create(
:title => "Roses",
:price => 36.50,
:artwork_image => "https://images.unsplash.com/photo-1451296043620-0cdb844d4c6d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a78ec9e723231662b3fbd573137496d6&auto=format&fit=crop&w=500&q=60",
:category => "grayscale")
user2.works << work5

work6 = Work.create(
:title => "Sonia",
:price => 25.99,
:artwork_image => "https://images.unsplash.com/photo-1454329030972-00583f5f051f?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e4fb9504f8af7a8c7660114413df03d9&auto=format&fit=crop&w=1042&q=80",
:category => "black-and-white")
user2.works << work6

work7 = Work.create(
:title => "John",
:price => 55.49,
:artwork_image => "https://images.unsplash.com/photo-1475868530036-7e1f42b9c91c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=9e3ebce528cd9c8550bea0bcf02e3542&auto=format&fit=crop&w=992&q=80",
:category => "colour ink")
user2.works << work7

work8 = Work.create(
:title => "Positive",
:price => 19.99,
:artwork_image => "https://images.unsplash.com/photo-1517613014533-70f3817be7e5?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed7934915cbbb8a845920e5eb318b774&auto=format&fit=crop&w=700&q=80",
:category => "colour splash")
user2.works << work8

work9 = Work.create(
:title => "Mirror",
:price => 125.99,
:artwork_image => "https://images.unsplash.com/photo-1498326458300-02cceca23326?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=1d65d8135e4d6b11a38ef2c391c276b9&auto=format&fit=crop&w=1050&q=80",
:category => "thick brushes")
user2.works << work9

work10 = Work.create(
:title => "Roses",
:price => 36.50,
:artwork_image => "https://images.unsplash.com/photo-1451296043620-0cdb844d4c6d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a78ec9e723231662b3fbd573137496d6&auto=format&fit=crop&w=500&q=60",
:category => "grayscale")
user2.works << work10

work11 = Work.create(
:title => "Yakuza",
:price => 20.99,
:artwork_image => "https://images.unsplash.com/photo-1494073257075-6ef676991b2a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=4a9a17da255af6643bdfa032a4104523&auto=format&fit=crop&w=634&q=80",
:category => "black-and-white")
user2.works << work11

work12 = Work.create(
:title => "Death",
:price => 55.49,
:artwork_image => "https://images.unsplash.com/photo-1475868530036-7e1f42b9c91c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=9e3ebce528cd9c8550bea0bcf02e3542&auto=format&fit=crop&w=992&q=80",
:category => "colour ink")
user2.works << work12

work13 = Work.create(
:title => "Positive",
:price => 19.99,
:artwork_image => "https://images.unsplash.com/photo-1517613014533-70f3817be7e5?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed7934915cbbb8a845920e5eb318b774&auto=format&fit=crop&w=700&q=80",
:category => "colour splash")
user2.works << work13

work14 = Work.create(
:title => "Mirror",
:price => 125.99,
:artwork_image => "https://images.unsplash.com/reserve/Ceszw9OoQD6rwMhfDl9R_render0006.jpg?ixlib=rb-0.3.5&s=bdf83f070a8999672f6085954b03c11b&auto=format&fit=crop&w=1050&q=80",
:category => "thick brushes")
user2.works << work14

work15 = Work.create(
:title => "Roses",
:price => 36.50,
:artwork_image => "https://images.unsplash.com/photo-1531399709603-e603402f01cf?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=263584261e7788443ff006f10904972b&auto=format&fit=crop&w=905&q=80",
:category => "grayscale")
user2.works << work15

work16 = Work.create(
:title => "Sonia",
:price => 25.99,
:artwork_image => "https://images.unsplash.com/photo-1454329030972-00583f5f051f?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e4fb9504f8af7a8c7660114413df03d9&auto=format&fit=crop&w=1042&q=80",
:category => "black-and-white")
user2.works << work16

work17 = Work.create(
:title => "John",
:price => 55.49,
:artwork_image => "https://images.unsplash.com/photo-1445912842705-7ee858b234c9?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=04bde96592ef985e6983b30695e33624&auto=format&fit=crop&w=1050&q=80",
:category => "colour ink")
user2.works << work17

work18 = Work.create(
:title => "Positive",
:price => 19.99,
:artwork_image => "https://images.unsplash.com/photo-1475695752828-6d2b0a83cf8a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=f0eb0eb54647b9151a8e00137f9f9da1&auto=format&fit=crop&w=1021&q=80",
:category => "colour splash")
user2.works << work18

work19 = Work.create(
:title => "Mirror",
:price => 125.99,
:artwork_image => "https://images.unsplash.com/photo-1475695752828-6d2b0a83cf8a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=f0eb0eb54647b9151a8e00137f9f9da1&auto=format&fit=crop&w=1021&q=80",
:category => "thick brushes")
user2.works << work19

work20 = Work.create(
:title => "Roses",
:price => 36.50,
:artwork_image => "https://images.unsplash.com/photo-1487980359585-fc92bf3fb9a7?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=931317f6d426a4302339febdcc5942e8&auto=format&fit=crop&w=1534&q=80",
:category => "grayscale")
user2.works << work20
# Now we add some visits
# We create 3 different visits for 3 different weekends for user 2

visit1 = Visit.create(
 :start_date => "2018-09-01",
 :end_date => "2018-09-05",
 :location  => "Glebe",
 :latitude => -33.878212,
 :longitude => 151.186773)
user2.visits << visit1

visit2 = Visit.create(
 :start_date => "2018-09-08",
 :end_date => "2018-09-09",
 :location  => "Pyrmont",
 :latitude => -33.869006,
 :longitude => 151.193346)

user2.visits << visit2

visit3 = Visit.create(
 :start_date => "2018-09-15",
 :end_date => "2018-09-16",
 :location  => "Surry Hills",
 :latitude =>  -33.883930,
 :longitude => 151.211148)



user2.visits << visit3


# We don't create any visits for user 3 (the new artist)
# We want the site to show them a message when they log in:
# "Create your first visit, so you can get customers"
#
# Now we create a booking for customer (user 4) and artist (user 2)
# When the user 4 logs in they should see:
# "Reminder, you have a booking at X time with artist Y"
#
# When user 2 logs in they should see:
# "Reminder, you a booking to do a tattoo for X time with Y."
booking1 = Booking.create(
  :date => "2018-09-02",
  :start_hour => 11)


user4.customer_bookings << booking1
user2.artist_bookings << booking1
