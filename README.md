# JsonApiNormalizer

Json API Normalizer gem is Ruby implementation of [json-api-normalizer](https://github.com/yury-dymov/json-api-normalizer) provides data normalization and formating for json api response like data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_api_normalizer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install json_api_normalizer

## Usage

Pass hash to initializer and call `normalize` to normalize data.
```ruby
data = { data: { id: '1', type: 'Manga', attributes: { name: "JoJo's Bizarre Adventure Part 6: Stone Ocean" } } }
JsonApiNormalizer.new(data).normalize
# output
# {"Manga"=>{"1"=>{"id"=>"1", "attributes"=>{"name"=>"JoJo's Bizarre Adventure Part 6: Stone Ocean"}, "type"=>"Manga"}}}
```

You also can call `to_h` which is an alias of `normalize`.
```ruby
data = { data: [
    { id: '1', type: 'Manga', attributes: { name: "JoJo's Bizarre Adventure Part 5: Golden Wind" } },
    { id: '2', type: 'Manga', attributes: { name: "JoJo's Bizarre Adventure Part 4: Diamond Is Unbreakable" } },
  ] }
JsonApiNormalizer.new(data).to_h
# output
#{"Manga"=> {
#  1"=>{"id"=>"1", "attributes"=>{"name"=>"JoJo's Bizarre Adventure Part 5 : Golden Wind"}, "type"=>"Manga"},
# "2"=>{"id"=>"2", "attributes"=>{"name"=>"JoJo's Bizarre Adventure Part 4: Diamond Is Unbreakable"}, "type"=>"Manga"}
# } }
```

Also normalizer supports includes normalization
```ruby
data = {
  data: [
    { id: 1, type: 'Manga', attributes: { name: "JoJo's Bizarre Adventure Part 3: Stardust Crusaders" },
      relationships: { author: { data: { id: 1, type: 'Author' } } } },
    { id: 2, type: 'Manga', attributes: { name: "JoJo's Bizarre Adventure Part 2: Battle Tendency" } ,
      relationships: { author: { data: { id: 1, type: 'Author' } } } }
  ],
  included: [{ id: 1, type: 'Author', attributes: { name: 'Hirohiko Araki' } }]
}
JsonApiNormalizer.new(data).to_h
# output =>
# {"Manga"=>
#   {1=>
#     {"id"=>1,
#      "attributes"=>{"name"=>"JoJo's Bizarre Adventure Part 3: Stardust Crusaders"},
#      "type"=>"Manga",
#      "relationships"=>{"author"=>{"data"=>{"id"=>1, "type"=>"Author"}}}},
#    2=>
#     {"id"=>2,
#      "attributes"=>{"name"=>"JoJo's Bizarre Adventure Part 2: Battle Tendency"},
#      "type"=>"Manga",
#      "relationships"=>{"author"=>{"data"=>{"id"=>1, "type"=>"Author"}}}}},
#  "Author"=>{1=>{"id"=>1, "attributes"=>{"name"=>"Hirohiko Araki"}, "type"=>"Author"}}}
```

And another feature of normalizer is keys and type case transformation. To see all allowed cases see [lucky_case](https://github.com/magynhard/lucky_case) gem
```ruby
data = { data: { id: '1', type: 'Manga', attributes: { name: "JoJo's Bizarre Adventure Part 1: Phantom Blood" } } }
JsonApiNormalizer.new(data, keys_case: :pascal_case, types_case: :upper_snake_case).normalize
# output
# {"MANGA"=>{"1"=>{"Id"=>"1", "Attributes"=>{"Name"=>"JoJo's Bizarre Adventure Part 1: Phantom Blood"}, "Type"=>"MANGA"}}}
```

Endpoint option is not supported now :(

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ar2emis/json_api_normalizer.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
