using System;

namespace Acme.HelloWord.Data {
    public class Word {
        public string Value { get; }
        public Language Language { get; }

        public Word(string val) {
            if (val.Contains(" ")) throw new ArgumentException("val");

            Value = val;
            Language = Language.English;
        }

        public override string ToString() {
            return Value;
        }
    }
}
