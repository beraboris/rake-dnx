using Xunit;
using System.Linq;

namespace Acme.HelloWorld.Data {
    public class ExclamationTest {
        [Fact]
        public void ToStringShouldEndWithBang() {
            var excl = new Exclamation(new Word("hello"), new Word("world"));
            Assert.Equal('!', excl.ToString().Last());
        }
    }
}
