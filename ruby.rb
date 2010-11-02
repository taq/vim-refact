module Test
   puts "bye"
   puts "tchau"
   puts "hasta la vista"
   # test class
   class Test
      puts "hi"
      puts "oi"
      puts "hola"
      def initialize
         @foo = "bar"
      end
      # test method
      def test
         puts "test!"
         puts "bye!"
         c = 0
         while c < 10
            puts "c = #{c}"
            c += 1
         end 
      end
      # test method, with foo argument
      def some_method(foo)
         foo.inspect
         puts "foo converted to string: #{foo}"
      end
   end
end
