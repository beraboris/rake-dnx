using System;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Acme.HelloWorld.Data {
    public class Word {
        public string Value { get; }
        public Language Language { get; }

        public Word(string val): this(val, Language.English) { }

        public Word(string val, Language language) {
            if (new Regex(@"\s").IsMatch(val))
                throw new ArgumentException("Word can't contain a witespace character", "val");

            Value = val;
            Language = language;
        }

        public override string ToString() {
            return Value;
        }

        public override bool Equals(object other) {
            if (other == null) return false;
            var otherWord = other as Word;
            if (otherWord == null) return false;

            return Value.Equals(otherWord.Value)
                && this.Language.Equals(otherWord.Language);
        }

        public override int GetHashCode() {
            var hash = 17;
            hash = hash * 23 + Value.GetHashCode();
            hash = hash * 23 + Language.GetHashCode();
            return hash;
        }

        public Word Capitalize() {
            return new Word(new StringBuilder()
                .Append(char.ToUpper(Value.First()))
                .Append(Value.Skip(1).ToArray())
                .ToString());
        }
    }
}
