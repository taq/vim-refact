public class Java {
   String s = "test";
   public Java() {
      for(int i=0; i<10; i++)
         System.out.println(i);
      this.s = "another test";
      System.out.println(this.s);
   }
   public static void main(String args[]){
      new Java();
   }
}
