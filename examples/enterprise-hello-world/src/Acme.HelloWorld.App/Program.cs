using System;
using Acme.HelloWorld.Data;

namespace Acme.HelloWorld.App {
    class Program {
        public static void Main(string[] args) {
            Console.WriteLine(new Exclamation(
                new Word("hello"), new Word("World")));
        }
    }
}
