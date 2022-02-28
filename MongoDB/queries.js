// 1.
db.listings.find().limit(2)
/*
[
  {
    _id: ObjectId("61aaa29bdd8bf2fba865baec"),
    id: 3831,
    listing_url: 'https://www.airbnb.com/rooms/3831',
    scrape_id: Long("20211102175544"),
    last_scraped: '2021-11-03',
    name: 'Whole flr w/private bdrm, bath & kitchen(pls read)',
    description: `Enjoy 500 s.f. top floor in 1899 brownstone, w/ wood & ceramic flooring throughout, roomy bdrm, & upgraded kitchen &
    bathroom.  This space is unique but one of the few legal AirBnbs with a totally private bedroom, private full bathroom and private
    eat-in kitchen, SO PLEASE READ "THE SPACE" CAREFULLY.  It's sunn
*/

// 2.
db.listings.distinct("host_name")
/*
[
  NaN,
  123,
  475,
  '',
  "'Cil",
  '(Ari) HENRY LEE',
  '(Email hidden by Airbnb)',
  '-TheQueensCornerLot',
  '2018Serenity',
*/

// 3.
db.listings.find({host_name:'Adelma'},{listing_url:1,name:1,host_name:1,_id:0})
/*
[
  {
    listing_url: 'https://www.airbnb.com/rooms/20390046',
    name: 'PRIVATE ROOM IN SHARED APARTMENT, UN VICINITY',
    host_name: 'Adelma'
  },
  {
    listing_url: 'https://www.airbnb.com/rooms/41999901',
    name: 'GORGEOUS PRIVATE ROOM IN ELEGANT SHARED APARTMENT',
    host_name: 'Adelma'
*/

// 4.
db.listings.find({$or:[{host_name:'Ada'},{host_name:'Ac'},{host_name:'Achk'}]},{_id:0,name:1,host_name:1,neighborhood_cleansed:1,price:1}).sort({host_name:1})
/*
[
  {
    name: 'Private Entrance Room in the HEART of the Village',
    host_name: 'Ac',
    price: '$150.00'
  },
  {
    name: 'Modern design in New York City',
    host_name: 'Ac',
    price: '$169.00'
*/

// 5.
db.listings.find({$and: [{neighbourhood_group_cleansed:'Brooklyn'},{bedrooms:{$gte:2}}]},
{_id:0,name:1,bedrooms:1,neighborhood_cleansed:1,price:1}).sort({review_scores_rating:-1}).limit(10)
/*
[
  {
    name: 'Gracious Brooklyn Limestone',
    bedrooms: 4,
    price: '$175.00'
  },
  {
    name: 'Penthouse in Bedford Stuyvesant',
    bedrooms: 2,
    price: '$150.00'
*/

// 6.
db.listings.aggregate(
    [{$group:{_id:'$host_name',listingsCount:{$sum:1}}}]
)
/*
[
  { _id: 'Nour', listingsCount: 4 },
  { _id: 'Lucyna', listingsCount: 1 },
  { _id: 'Helen', listingsCount: 25 },
  { _id: 'Haydenn', listingsCount: 1 },
  { _id: 'Opera House Hotel', listingsCount: 1 },
  { _id: 'Diuly Cristine', listingsCount: 1 },
  { _id: 'Joy Karen', listingsCount: 1 },
  { _id: 'Eric', listingsCount: 96 },
  { _id: 'Vladimir', listingsCount: 12 },
*/

// 7.
db.listings.aggregate(
    {$group:{_id:'$host_name',listingsCount:{$sum:1}}},
    {$project: {_id:0, listingsCount: 1, host: "$_id"}}).sort({listingsCount:-1})
/*
[
  { listingsCount: 400, host: 'June' },
  { listingsCount: 311, host: 'Michael' },
  { listingsCount: 304, host: 'Blueground' },
  { listingsCount: 251, host: 'Karen' },
  { listingsCount: 238, host: 'David' },
  { listingsCount: 222, host: 'Jeniffer' },
  { listingsCount: 210, host: 'Alex' },
  { listingsCount: 178, host: 'Daniel' },
  { listingsCount: 175, host: 'John' },
*/

// 8.
var match={$match: {$and: [{neighbourhood_group_cleansed:'Brooklyn'},{bedrooms:{$gte:1}},{beds:{$gte:1}}]}}
var b_to_b_ratio={$divide: ["$bedrooms","$beds"]}
var project={$project: {_id:0,name:1,neighborhood_cleansed:1,bedrooms:1,beds:1,bedroomBedRatio: b_to_b_ratio}}
var order={$sort: {neighborhood_cleansed:1}}
db.listings.aggregate(match,project,order)
/*
[
  {
    name: 'Whole flr w/private bdrm, bath & kitchen(pls read)',
    bedrooms: 1,
    beds: 3,
    bedroomBedRatio: 0.3333333333333333
  },
  { name: 'BlissArtsSpace!', bedrooms: 1, beds: 1, bedroomBedRatio: 1 },
  {
    name: 'Spacious Brooklyn Duplex, Patio + Garden',
*/

// 9.
var match={$match: {$and: [{bedrooms:{$gte:1}},{beds:{$gte:1}}]}}
var b_to_b_ratio={$divide: ["$bedrooms","$beds"]}
var project={$project: {_id:0,neighbourhood_group_cleansed:1,bedroomBedRatio:b_to_b_ratio}}
var group={$group: {_id:'$neighbourhood_group_cleansed',avgBedRatio:{$avg:"$bedroomBedRatio"}}}
var order={$sort: {avgBedRatio:-1}}
db.listings.aggregate(match,project,group,order)
/*
[
  { _id: 'Brooklyn', avgBedRatio: 0.925893863719455 },
  { _id: 'Manhattan', avgBedRatio: 0.9020413600110374 },
  { _id: 'Queens', avgBedRatio: 0.88898632498287 },
  { _id: 'Bronx', avgBedRatio: 0.8876594739329029 },
  { _id: 'Staten Island', avgBedRatio: 0.83395660461987 }
]*/

// 10.
var match={$match: {neighbourhood_group_cleansed:"Manhattan"}}
var group={$group: {_id:'$neighbourhood_cleansed',listingsCount:{$sum:1}, avgRating:{$avg:'$review_scores_rating'}}}
var match2={$match:{listingsCount:{$gt:100}}}
var order={$sort: {avgRating:-1}}
db.listings.aggregate(match,group,match2,order)
/*
[
  {
    _id: 'West Village',
    listingsCount: 520,
    avgRating: 4.700544554455446
  },
  { _id: 'Nolita', listingsCount: 212, avgRating: 4.694313725490196 },
  {
    _id: 'Gramercy',
    listingsCount: 227,
*/