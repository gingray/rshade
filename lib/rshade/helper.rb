module RShade
  module Helper
    def pretty_print(root)
      str = StringIO.new
      str.write "\n\n"
      str.write "---\n".colorize(:yellow)
      root.traverse do |node|
        str.write"#{' ' * node.level}#{node.pretty}\n" if node.valid?
      end
      str.write '---'.colorize(:yellow)
      str.string
    end
  end
end
