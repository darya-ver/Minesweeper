import de.bezier.guido.*;

private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private static int NUM_BOMS = 30;

private MSButton[][] buttons; 
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();
//private ArrayList <MSButton> nonBombs = new ArrayList <MSButton>();

void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for(int c = 0; c<NUM_COLS; c++)
        for(int r = 0; r<NUM_ROWS; r++)
            buttons[r][c] = new MSButton(r,c);
    
    setBombs();
}

public void setBombs()
{
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
    background(0);

    if(isWon())
        displayWinningMessage();
}

public boolean isWon()
{
    int numberOfClickedThings = 0;

    for(int c = 0; c<NUM_COLS; c++)
        for(int r = 0; r<NUM_ROWS; r++)
            if(buttons[r][c].isClicked()==true)
                numberOfClickedThings ++;

    if(numberOfClickedThings == NUM_ROWS*NUM_COLS)  return true;
    return false;
}

public void displayLosingMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("L");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLose();
    
    for(MSButton bombb : bombs)
        bombb.setClicked(true);
}

public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("W");
    buttons[NUM_ROWS/2][NUM_COLS/2].setWin();
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, win, lose;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = win = lose = false;
        Interactive.add( this ); // register it with the manager
    }

    public boolean isMarked(){return marked;}

    public boolean isClicked(){return clicked;}

    public void setClicked(boolean sett){clicked = sett;}

    public void setWin(){win = !win;}

    public void setLose(){lose = !lose;}
    
    public void mousePressed () 
    {
        clicked = true;

        if(keyPressed && key=='c')
        {
            marked = !marked;
            if(marked==false)
              clicked = false;
        }
        else if(bombs.contains(this))
            displayLosingMessage();
        else if(countBombs(r,c)!=0)
            label=""+countBombs(r,c);
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
        else if(win)
            fill(0,255,0);
        else if(lose)
            fill(0,0,255);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }

    public void setLabel(String newLabel){label = newLabel;}
    
    public boolean isValid(int r, int c)
    {
        if(r<NUM_ROWS&&r>=0&&c<NUM_COLS&&c>=0) return true;
            
        return false;
    }

    public int countBombs(int row, int col)
    {
        int numBombs = 0;

        for(int i = -1; i <=1; i++)
            for(int j = -1; j <=1; j++)
                if(isValid(row+i,col+j))
                    if(bombs.contains(buttons[row+i][col+j]))
                        numBombs++;
        return numBombs;
    }
}


































