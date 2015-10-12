using Xunit;
using System;

namespace Acme.HelloWord.Data {
    public class WordTest {
        [Fact]
        public void ConstructorShouldBlowupWhenWordHasSpaces() {
            Assert.Throws<ArgumentException>(() => new Word("foo bar"));
        }
    }
}
