# RProject

What you will need: 
  
  * Ruby (2.2.0)
  * Redis (For sidekiq) `brew install redis`
  * MongoDB `brew install mongo`

## Usage

run the app `thin start`
run sidekiq `sidekiq -r ./lib/r_project.rb`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/r_project/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
