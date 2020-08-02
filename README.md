# RShade  
 
![warcraft shade](https://github.com/gingray/rshade/raw/master/shade.jpg)

Ruby Shade or RShade gem to help you to reveal what lines of code are used in program execution.
  
```ruby
trace = RShade::Trace.reveal do  
  #your code here
end
trace.show
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
# show everything
custom_filter = ->(evt) { true }
rshade_reveal(filter: custom_filter) do
  variant.save!
end

# show everything
custom_filter = ->(evt) { true }
trace = RShade::Trace.reveal(filter: custom_filter) do
  #your code here
end
trace.show

# evt is hash with keys
# evt = { level: @level, path: evt.path, lineno: evt.lineno, klass: evt.defined_class, method_name: evt.method_id, vars: process_locals(evt) }
# {:level=>1, :path=>"...rvm/gems/ruby-2.6.6/gems/rails-controller-testing-1.0.2/lib/rails/controller/testing/integration.rb", :lineno=>10, :klass=>Rails::Controller::Testing::Integration, :method_name=>:get, :vars=>{:args=>[:arg1, {:params=>{:search_query=>"boo"}, :xhr=>true}], :method=>"get"}}
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
