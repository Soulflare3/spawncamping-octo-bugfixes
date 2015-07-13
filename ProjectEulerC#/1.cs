using System;

namespace ProjectEuler
{
    internal class Program
    {
        // If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
        // Find the sum of all the multiples of 3 or 5 below 1000.

        private static int QueryVal = 1000;
        private static int total = 0;
        private static int[] divisors = { 3, 5 };
        private static string problem = "https://projecteuler.net/problem=1";

        private static void Main(string[] args)
        {
            inits();
            go();
            end();
        }

        private static void go()
        {
            for (int i = 1; i < QueryVal; i++)
            {
                bool search = false;
                foreach (var item in divisors)
                {
                    if (i % item == 0) //actual calculation, most of this program is just fluff (Modulus Division)
                    {
                        search = true;
                        print("Multiple found: " + i);
                        break; //no need to continue for this i
                    }
                }

                if (search)
                {
                    total += i; //add current i to total
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

        private static string getDivisors() //only used in init print, basically debug
        {
            string returnString = "";
            foreach (var item in divisors)
                returnString += "|" + item;
            return returnString.Substring(1, returnString.Length - 1); //Chop first character, laziness ftw
        }

        private static void inits()
        {
            print("Query Value: " + QueryVal);
            print("Starting Total: " + total);
            print("Divisors: " + getDivisors());
        }

        private static void end()
        {
            print(problem);
            print("Done");
            read();
        }
    }
}
