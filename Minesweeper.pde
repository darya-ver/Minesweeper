import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private static int NUM_BOMS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int c = 0; c<NUM_COLS; c++)
        for(int r = 0; r<NUM_ROWS; r++)
            buttons[r][c] = new MSButton(r,c);
    
    setBombs();

    //textAlign(CENTER);
}
public void setBombs()
{
    //your code
    for(int i = 0; i<NUM_BOMS; i++)
    {
        int coll = (int)(Math.random()*NUM_COLS);
        int roww = (int)(Math.random()*NUM_ROWS);
        
        if(!bombs.contains(buttons[roww][coll]))
            bombs.add(buttons[roww][coll]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(keyPressed && key=='c')
        {
            marked = !marked;
            if(marked==false)
              clicked = false;
        }
        else if(bombs.contains(this))
            displayLosingMessage();
        else if(countBombs(r,c)!=0)
            label=Integer.toString(countBombs(r,c));
        else
        {
            if(isValid(r,c-1) && buttons[r][c-1].isClicked()==false)
                buttons[r][c-1].mousePressed();

            if(isValid(r-1,c-1) && buttons[r-1][c-1].isClicked()==false)
                buttons[r-1][c-1].mousePressed();

            if(isValid(r+1,c-1) && buttons[r+1][c-1].isClicked()==false)
                buttons[r+1][c-1].mousePressed();

            if(isValid(r,c+1) && buttons[r][c+1].isClicked()==false)
                buttons[r][c+1].mousePressed();

            if(isValid(r+1,c+1) && buttons[r+1][c+1].isClicked()==false)
                buttons[r+1][c+1].mousePressed();

            if(isValid(r-1,c+1) && buttons[r-1][c+1].isClicked()==false)
                buttons[r-1][c+1].mousePressed();

            if(isValid(r+1,c) && buttons[r+1][c].isClicked()==false)
                buttons[r+1][c].mousePressed();

            if(isValid(r-1,c) && buttons[r-1][c].isClicked()==false)
                buttons[r-1][c].mousePressed();
            /*for(int i = -1; i <=1; i++)
                for(int j = -1; j <=1; j++)
                {   
                    if(isValid(r+i,c+j))
                        if(!buttons[r+i][c+j].isClicked())
                            buttons[r+i][c+j].mousePressed();
                }
                */
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(r<NUM_ROWS&&r>=0&&c<NUM_COLS&&c>=0) return true;
            
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        //your code here
         for(int i = -1; i <=1; i++)
            for(int j = -1; j <=1; j++)
                if(isValid(row+i,col+j))
                    if(bombs.contains(buttons[row+i][col+j]))
                        numBombs++;
        return numBombs;
    }
}


































