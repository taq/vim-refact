module Test
   # test class
   class Test
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
   end
end
