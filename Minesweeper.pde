import de.bezier.guido.*;

private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private static final int NUM_BOMS = 50;

private ArrayList <Button> changeSizeButtons = new ArrayList <Button>();

private PImage bombImg;
private PImage flagImg;

String urlBomb = "https://d30y9cdsu7xlg0.cloudfront.net/png/54644-200.png";
String urlFlag = "http://clipart-finder.com/data/mini/1312140781.png";

private MSButton[][] buttons;

private ArrayList <MSButton> bombs = new ArrayList <MSButton>();

private boolean lost = false;

void setup ()
{
    size(1000, 700);
    textAlign(CENTER,CENTER);

    bombImg = loadImage(urlBomb, "png");
    flagImg = loadImage(urlFlag, "png");
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for(int c = 0; c<NUM_COLS; c++)
        for(int r = 0; r<NUM_ROWS; r++)
            buttons[r][c] = new MSButton(r,c);

    setBombs();
    imageMode(CENTER);
}

public void setBombs()
{
    for(int i = 0; i<NUM_BOMS; i++)
    {
        int coll = (int)(Math.random()*NUM_COLS);
        int roww = (int)(Math.random()*NUM_ROWS);
        
        if(!bombs.contains(buttons[roww][coll]))
        {
            bombs.add(buttons[roww][coll]);
            //System.out.println("("+roww+","+coll+")");
        }
    }
}

public void draw ()
{
    background(0);

    if(isWon())
        displayWinningMessage();

    if(lost)
        displayLosingMessage();
}

public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            if(!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
                return false;

    return true; 
}

public void displayLosingMessage()
{
    for(MSButton bombb : bombs)
    {
        bombb.setMarked(false);
        bombb.setClicked(true);
    }
    fill(110);
    text("AWE you lost :(", height+(width-height)/2, 50);
}

public void displayWinningMessage()
{
    fill(110);
    text("OMG you won!", height+(width-height)/2, 50);

}


public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 700/NUM_COLS;
        height = 700/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    public boolean isMarked(){return marked;}

    public boolean isClicked(){return clicked;}

    public void setClicked(boolean sett){clicked = sett;}

    public void setMarked(boolean sett){marked = sett;}

    public void mousePressed () 
    {
        clicked = true;

        if(mouseButton == RIGHT)
        {
            marked = !marked;
            
            if(marked==false)
                clicked = false;
        }

        else if(bombs.contains(this))
            lost=true;

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
        textSize(30);
        stroke(100);
        strokeWeight(2);

        if (marked)
        {
            fill(150);
            rect(x, y, width, height);

            //making the box look 3D
            noStroke();
            
            fill(255);
            quad(x, y, x+5, y, x+5, y+height-5, x, y+height);
            quad(x, y, x+width, y, x+width-5, y+5, x, y+5);
            
            fill(100);
            quad(x+5, y+height-5, x+width, y+height-5, x+width, y+height, x, y+height);
            quad(x+width-5, y+5, x+width, y, x+width, y+height, x+width-5, y+height);
            
            image(flagImg, x + width/2+3, y+ height/2, width-15, height-15);
        }

        else if(clicked && bombs.contains(this)) 
        {
            fill(150);
            rect(x, y, width, height);          
            //fill(200);
            image(bombImg, x + width/2+3, y+ height/2, width, height);
        }

        else if(clicked)
        {
            fill(150); 
            rect(x, y, width, height);
        }

        else 
        {
            fill(150);
            rect(x, y, width, height);

            //making the box look 3D
            noStroke();
            
            fill(255);
            quad(x, y, x+5, y, x+5, y+height-5, x, y+height);
            quad(x, y, x+width, y, x+width-5, y+5, x, y+5);
            
            fill(100);
            quad(x+5, y+height-5, x+width, y+height-5, x+width, y+height, x, y+height);
            quad(x+width-5, y+5, x+width, y, x+width, y+height, x+width-5, y+height);
        }

        if(countBombs(r,c) == 1)    fill(0,0,255);
        else if(countBombs(r,c) == 2)   fill(0,102,0);
        else if(countBombs(r,c) == 3)   fill(255,0,0);

        text(label,x+width/2,y+height/2-3);
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


































