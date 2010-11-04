<?php
class ClassName {
   public $var = 1;
   print "bye";
   print "tchau";
   function test(p1) {
      echo "$p1";
      echo "hi";
      echo "ola";
      $c = 0;
      while($c < 10) {
         print "c = $c\n";
         $c ++;
      }
   }
   function show_var() {
      print $this->var;
   }
}
?>
