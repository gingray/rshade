module RShade
  module Helper
    def pretty_print(root)
      str = StringIO.new
      str.write "\n\n"
      str.write "---\n".colorize(:yellow)
      root.traverse do |node|
        level = 0
        parent = node.valid_parent
        level = parent.level if parent
        str.write"#{' ' * level}#{node.pretty}\n" if node.valid?
      end
      str.write '---'.colorize(:yellow)
      str.string
    end
  end
end
