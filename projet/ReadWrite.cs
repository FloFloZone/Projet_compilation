/*
* file: ReadWrite.cs
* version: 0.9.0
*/

using System;

public class ReadWrite {
    static public void Main () {
        String str;
        bool end = false;
        while(end != true){
            Console.Write("Enter a string (stop to quit): ");
            str = Console.ReadLine();
            if(str == "stop")
                end = true;
            Console.WriteLine("You entered: " + str);
        }
    }
}