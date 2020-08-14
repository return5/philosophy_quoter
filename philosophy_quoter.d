//-------------------------- Description ------------------------------
//  Program which allows user to display a quote picked from random.
//  Quotes are located in file 'quotes.txt' by default
//  Quotes can besaved in program to a file name 'favorites.txt'
//  user can also choose to pick a random quote form 'favorites.txt'
//  uses gtkd for the GUI.
//
//------------------------- License ----------------------------------
//  license: GPL 3.0        Author: github/return5
//
//  Copyright (C) <2020>  <return5>
//
//  This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// ----------------------- imports ----------------------------------------
import std.string;
import std.regex;
import std.file;
import std.stdio;
import std.random;
import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gtk.TextView;
import gtk.TextBuffer;
import gtk.Box;
import gdk.Event;
import gtk.Grid;
import gtk.ScrolledWindow;

// ----------------------- global vars -------------------------------------
Random rnd;            //random number generator.


// ----------------------- functions ----------------------------------------


void displayQuote(in string quote,TextBuffer txt) {
    txt.setText(quote);
}

//get a quote at random from the array of quotes. 
void getQuote(string [] quote_arr,out string quote,TextBuffer txt){
    quote = strip(quote_arr.choice(rnd));   //get a random quote from quote_arr
    if(quote.empty == false) {  //if quote is not an empty string then display it.
        displayQuote(quote,txt);
    }
    else {
        getQuote(quote_arr,quote,txt);
    }
}

//get an array of strings, each index is a quote from file.
string []getQuoteArr(in string file) {
    if(file.exists == true) { //if the file exist
        //read file and break each quote into a string. each quote is an index in a string array. return the array.
        return split(readText(file),regex("(?<=\t* +- +.+)[\r|\n]+"));
    }
    else {  //if file doesnt exist then return null
        return null;
    }
}

//save a favorite quote to file. 
void saveToFavorites(in string quote,in string file) {
    append(file,quote~"\n\n");
}

//set up the random number generator
void setRnd() {
    rnd = Random();                 //create random number generator
    rnd.seed(unpredictableSeed);   //seed rand number generator 
}

Grid makeButtonGrid(out string quote,in string file_name,in string favorites,string[] quote_arr,string[] fav_arr,TextBuffer txt) {
    Button button       = new Button("save to favorites");          //button which will save a quote to favorites
    Button button2      = new Button("get favorite quote");        //buton with will get a quote form favorites file
    Button button3      = new Button("get random quote");          //button which will get quote from quotes file
    Grid grid           = new Grid();                              //grid to hold the three buttons
	button.addOnClicked(delegate void(Button b) {saveToFavorites(quote,favorites); });   //on clicking button save quote to favorite
	button2.addOnClicked(delegate void(Button b) {getQuote(fav_arr,quote,txt); });       //on clicking button2 get a quote from favorites
	button3.addOnClicked(delegate void(Button b) {getQuote(quote_arr,quote,txt); });     //on clicking button3 get a quote from quotes file
    grid.setColumnSpacing(20);
    grid.attach(button,0,100,2,2);         //add button 1 to grid
    grid.attach(button2,10,100,2,2);        //add button 2 to grid
    grid.attach(button3,20,100,2,2);      //add button3 to grid
    return grid;
}

Box makeScrollWindow(out TextBuffer txt) { 
    Box box             = new Box(Orientation.VERTICAL,10);        //box to hold scrolling window
    ScrolledWindow scrl = new ScrolledWindow();                    //scrolling window which is where text will be displayed
    TextView tv         = new TextView();                         //text viewer to display text of quote
    txt                 = tv.getBuffer();                         //text buffer to hold quote to display
    scrl.add(tv);
    box.packStart(scrl,true,true,0);     //put text view in box
    return box;
}

//crate the user interface. should have a scrollign window with a text view and three buttons below it.
void setUpGui(string[] args,string quote,in string file_name,in string favorites,string[] quote_arr,string[] fav_arr) {
    Main.init(args);
	MainWindow window   = new MainWindow("Philosophy Quotes");      //make main window
    TextBuffer txt;                                                 //textBuffer to hold the quote
    Box box             = makeScrollWindow(txt);                    //box which holds teh scrolling window which displays the quote.
    Box w_box           = new Box(Orientation.VERTICAL,10);        //box to hold grid and scrolling window box
    Grid grid           = makeButtonGrid(quote,file_name,favorites,quote_arr,fav_arr,txt); //grid which holds the three buttons.
    w_box.packEnd(grid,true,true,5); //put grid in w_box
    w_box.packEnd(box,true,true,10);  //put box into w_box
    window.setDefaultSize(750,80);	 //set default size of main window
    window.add(w_box);              //add w_box to main window
    window.showAll();              //show all widgets in main window
    window.addOnDestroy(delegate void(Widget w) { quitApp(); } );
}

//when app is exited, close it.
void quitApp() {
    Main.quit();
}

void main(string[] args) {
    string file_name   = "quotes.txt";                     //name of file holding quotes
    string favorites   = "favorites.txt";                 //name of file where favorite quotes are saved to.
    string[] quote_arr = getQuoteArr(file_name);       //make a string array. each quote in file is an index in array.
    if(quote_arr != null) {    
        string quote;
        string[] fav_arr = getQuoteArr(favorites);
        setRnd();
        setUpGui(args,quote,file_name,favorites,quote_arr,fav_arr);
        Main.run();
    }
    else {
        writeln("error, file does not exist or is not named '" ~file_name,"', pleae try again.");
    }
}

