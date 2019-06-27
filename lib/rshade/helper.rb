module RShade
  module Helper
    def pretty_print(root)
      str = StringIO.new
      root.traverse do |node|
        str.write"#{' ' * node.level}#{node.pretty}\n" if node.valid?
      end
      str.string
    end
  end
end
