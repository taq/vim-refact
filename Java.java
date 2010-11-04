public class Java {
   String s = "test";
   System.out.println("hi");
   System.out.println("oi");
   System.out.println("bye");
   System.out.println("tchau");
   public Java() {
      for(int i=0; i<10; i++)
         System.out.println(i);
      this.s = "another test";
      System.out.println(this.s);
   }
   public static void main(String args[]){
      int a = 100;
      
      a += 2;
      a  -= 3;
      a *= 4;
      a   /= 5;
      a     ++;
      a  --;
      System.out.println(a);
      new Java();
   }
}
