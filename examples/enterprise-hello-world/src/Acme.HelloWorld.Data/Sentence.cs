using System.Linq;

namespace Acme.HelloWorld.Data {
    public class Sentence {
        private readonly Word[] _words;

        public Sentence(params Word[] words) {
            _words = words;
        }

        public override string ToString() {
            return string.Join(" ",
                _words.Select((w, i) => i == 0 ? w.Capitalize() : w )) + ".";
        }

        public override bool Equals(object other) {
            if (other == null) return false;
            var otherSentence = other as Sentence;
            if (otherSentence == null) return false;

            return _words.SequenceEqual(otherSentence._words);
        }

        public override int GetHashCode() {
            return _words.Aggregate(17, (h, i) => h * 23 + i.GetHashCode());
        }
    }
}
