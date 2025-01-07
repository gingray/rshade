# RShade  
<p align="center">
  <img src="https://github.com/gingray/rshade/raw/master/shade.jpg">
</p>

RShade is a debugging/code exploration tool based on `TracePoint` functionality. 
Recent years I've working with relatively huge legacy code and I need a tool which can help me to figure out what is going on due execution. 
Luckely Ruby have build in functionality to achieve it, but it's pretty low level. It was my motivation to create `RShade` it helps me to save tons of time 
when I face with something not trivial or a good start point to create dependency map when I do refactoring or bugfix. Tool still in beta and it's possible that there
is some bugs, but it's do the job.  

## How it works?
```shell
gem install rshade
```
Simple wrap code that you want to check in to block and it will pretty print all of the calls which was made in this block with pointing line of executions, variables what was pass
inside methods and variables what was return
```ruby
RShade::Trace.reveal do  
  #your code here
end.show
```
Due that tool create a detailed log with all of the steps of execution it's hard to read (it's can easelly be 20 - 30k lines because it's shows not only your custom code but also
code in gems that are involved in execution). `RShade` have filters to tackle this problem. Default filter is illiminate all code related to gems and only expose app code itself. You can 
change this behaviour or add your own filter. Even when some piece of code are not shown due filtration order of calls and execution still shown in correct way.

## Table of Contents
 - [Configuration](#configuration)
 - [Filters](#filters)
   - [Filter by path include](#filter-by-path-include)
   - [Filter by path exclude](#filter-by-path-exclude)
   - [Filter by variable name or value](#filter-by-variable-name-or-value)
 - [Examples](#examples)

### Configuration
```ruby
config = ::RShade::Config.default

RShade::Trace.reveal(config) do
end.show
```
### Filters
Filters by default represent by expression `(include_path or variable_match) or (not exclude_path)`
Filters can be chained like:
```ruby
config = ::RShade::Config.default.include_paths { |paths| paths << /devise/ }
                                  .exclude_paths { |paths| paths << /warden/ } 
                                  .match_variable { |name, value| name == :current_user }
```
#### Filter by path include
`paths` - is array which accept regex or string
```ruby
config = ::RShade::Config.default.include_paths { |paths| paths << /devise/ }

RShade::Trace.reveal(config) do
   #your code
end.show

```
#### Filter by path exclude
`paths` - is array which accept regex or string
```ruby
config = ::RShade::Config.default.exclude_paths { |paths| paths << /devise/ }

RShade::Trace.reveal(config) do
   #your code
end.show
```

#### Filter by variable name or value
`name` - represent variable name as symbol
`value` - actual variable value
```ruby
config = ::RShade::Config.default.match_variable { |name, value| name == :current_user }

RShade::Trace.reveal(config) do
   #your code
end.show
```

## Examples
I've took example from https://github.com/spree/spree code base. Wrap code to take a look what code is in use when you save variant.
On such huge codebase as spree it's helpful to know what callbacks are triggered and so on.
```ruby
  context '#cost_currency' do
    context 'when cost currency is nil' do
      before { variant.cost_currency = nil }

      it 'populates cost currency with the default value on save' do
         RShade::Trace.reveal do
          variant.save!
        end
        expect(variant.cost_currency).to eql 'USD'
      end
    end
  end
```

Below is example how output will look like.
As you can see all code that have been in use is printed.
[![asciicast](https://asciinema.org/a/MR5KL7TmHmYRUhwBUWQjBI373.svg)](https://asciinema.org/a/MR5KL7TmHmYRUhwBUWQjBI373)

## Stack reveal
Config

```ruby
::RShade::Config::Registry.instance.stack_config do |config|
   config.exclude_gems!
   filepath = File.join(Rails.root, 'log', 'rshade-stack.json.log')
   config.formatter!(:json, { filepath: filepath, pretty: false })
end
```

Execute (put in any place where you want reveal stack)
```ruby
::RShade::Stack.trace
```

## TODO  
Use stack to keep connections between current method and caller  
take a look on https://github.com/matugm/visual-call-graph  
  
## Contributing  
  
Bug reports and pull requests are welcome on GitHub at https://github.com/gingray/rshade.  
  
## License  
  
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
