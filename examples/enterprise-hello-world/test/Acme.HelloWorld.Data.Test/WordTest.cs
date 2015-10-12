using Xunit;
using System;

namespace Acme.HelloWord.Data {
    public class WordTest {
        [Theory]
        [InlineData("foo bar")]
        [InlineData("foo\tbar")]
        [InlineData("foo\nbar")]
        [InlineData("foo\rbar")]
        public void ConstructorShouldBlowupWhenWordHasSpaces(string val) {
            Assert.Throws<ArgumentException>(() => new Word(val));
        }

        [Fact]
        public void OneArgConstructorShouldDefaultToEnglish() {
            Assert.Equal(Language.English, new Word("something").Language);
        }

        [Fact]
        public void ToStringShouldReturnValue() {
            Assert.Equal("Stuff", new Word("Stuff").ToString());
        }

        [Fact]
        public void EqualsShouldMatchOnValueAndLanguage() {
            Assert.Equal(new Word("Foobar"), new Word("Foobar"));
        }

        [Fact]
        public void GetHashCodeShouldMatchForSameObject() {
            Assert.Equal(new Word("Thing").GetHashCode(),
                new Word("Thing").GetHashCode());
        }
    }
}
