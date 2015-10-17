using Xunit;
using System.Linq;

namespace Acme.HelloWorld.Data {
    public class SentenceTest {
        [Fact]
        public void ToStringShouldStartWithACapitalLetter() {
            var sentence = new Sentence(
                new Word("fi"), new Word("fo"), new Word("fum"));

            Assert.Equal('F', sentence.ToString()[0]);
        }

        [Fact]
        public void ToStringShouldEndWithPeriod() {
            var sentence = new Sentence(new Word("foo"), new Word("bar"));

            Assert.Equal('.', sentence.ToString().Last());
        }

        [Fact]
        public void ToStringShouldSpaceWordsWithSpaces() {
            var sentence = new Sentence(new Word("foo"), new Word("bar"));

            Assert.Equal("Foo bar.", sentence.ToString());
        }

        [Fact]
        public void EqualsShouldWord() {
            var s1 = new Sentence(
                new Word("fi"), new Word("fo"), new Word("fun"));
            var s2 = new Sentence(
                new Word("fi"), new Word("fo"), new Word("fun"));

            Assert.Equal(s1, s2);
        }

        [Fact]
        public void GetHashCodeShouldMatchForSameObject() {
            var s1 = new Sentence(
                new Word("fi"), new Word("fo"), new Word("fun"));
            var s2 = new Sentence(
                new Word("fi"), new Word("fo"), new Word("fun"));

            Assert.Equal(s1.GetHashCode(), s2.GetHashCode());
        }
    }
}
