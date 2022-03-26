# RShade  
 
![warcraft shade](https://github.com/gingray/rshade/raw/master/shade.jpg)

Ruby Shade or RShade gem to help you to reveal what lines of code are used in program execution.
```ruby
# with default config (exclude ruby internals and code from gem files)
RShade::Trace.reveal do  
  #your code here
end.show

# with custom config
config = ::RShade::Config.default.include_paths { |paths| paths << /devise/ }

RShade::Trace.reveal(config) do
  #your code here
end.show


#rspec
 rshade_reveal do
   #code here
 end 

```
## Example
I've took example from https://github.com/spree/spree code base. Wrap code to take a look what code is in use when you save variant.
On such huge codebase as spree it's helpful to know what callbacks are triggered and so on.
```ruby
  context '#cost_currency' do
    context 'when cost currency is nil' do
      before { variant.cost_currency = nil }

      it 'populates cost currency with the default value on save', focus: true do
        rshade_reveal do
          variant.save!
        end
        expect(variant.cost_currency).to eql 'USD'
      end
    end
  end
```
by default gem filter everything related to your installed gems and shows only what related to your app, to change this behaviour  
```ruby
# create empty config which reveal everything
config = ::RShade::Config.create
trace = RShade::Trace.reveal(config) do
  #your code here
end
trace.show

```
Below is example how output will look like.
As you can see all code that have been in use is printed.
[![asciicast](https://asciinema.org/a/MR5KL7TmHmYRUhwBUWQjBI373.svg)](https://asciinema.org/a/MR5KL7TmHmYRUhwBUWQjBI373)

## Installation  
  
Add this line to your application's Gemfile:  
  
```ruby  
gem 'rshade'  
```  
  
## TODO  
Use stack to keep connections between current method and caller  
take a look on https://github.com/matugm/visual-call-graph  
  
## Contributing  
  
Bug reports and pull requests are welcome on GitHub at https://github.com/gingray/rshade.  
  
## License  
  
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
