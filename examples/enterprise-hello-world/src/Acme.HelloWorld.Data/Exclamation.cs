namespace Acme.HelloWorld.Data {
    public class Exclamation : Sentence {
        public Exclamation(params Word[] words): base(words) {}

        protected override string Terminator => "!";
    }
}
