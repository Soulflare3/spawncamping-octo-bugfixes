using System;

namespace ProjectEuler
{
    internal class Program
    {
        /*
         * 
         * Each new term in the Fibonacci sequence is generated by adding the previous two terms.
         * By starting with 1 and 2, the first 10 terms will be:
         * 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
         * By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
         * 
         */

        private static int maxVal = 4000000;
        private static int total = 0;
        private static string problem = "https://projecteuler.net/problem=2";

        private static void Main(string[] args)
        {
            inits();
            go();
            end();
        }

        private static void go()
        {
            int old = 0;
            int current = 1;
            int sum = 0;
            while(current < maxVal)
            {
                    sum = old + current;

                    old = current;
                    current = sum;
                    if (current % 2 == 0)
                    {
                        total += sum;
                    }
      
            }
            print("Total Sum: " + total);
        }

        private static void print(string text)
        {
            Console.WriteLine(text);
        }

        private static string read()
        {
            return Console.ReadLine();
        }

        private static void inits()
        {
            print("Max Value: " + maxVal);
            print("Starting Total: " + total);
        }

        private static void end()
        {
            print(problem);
            print("Done");
            read();
        }
    }
}