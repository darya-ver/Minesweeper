import de.bezier.guido.*;

private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private int NUM_BOMS = 20;
private int NUM_NON_BOMS = NUM_ROWS*NUM_COLS - NUM_BOMS;

//private Button moreBoxes = new Button(900,100,"boxSizePlus");
private ArrayList <Button> changeSizeButtons = new ArrayList <Button>();

//private PImage bombImg;
private PImage webImg;

String url = "https://d30y9cdsu7xlg0.cloudfront.net/png/54644-200.png";
  // Load image from a web server
  //webImg = loadImage(url, "png");

private MSButton[][] buttons; 
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();

void setup ()
{
    size(1000, 800);
    textAlign(CENTER,CENTER);

    //bombImg = loadImage("bomb2.png");
    webImg = loadImage(url, "png");
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for(int c = 0; c<NUM_COLS; c++)
        for(int r = 0; r<NUM_ROWS; r++)
            buttons[r][c] = new MSButton(r,c);

    //changeSizeButtons.add(new Button(900, 100, "boxSizePlus"));
    //changeSizeButtons.add(new Button(950, 100, "boxSizeMinus"));
    changeSizeButtons.add(new Button(900, 200, "numBoxesPlus"));
    changeSizeButtons.add(new Button(950, 200, "numBoxesMinus"));
    
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

    //gameRunning();
}

public void gameRunning()
{
    for(int i = 0; i<changeSizeButtons.size(); i++)
    {
        changeSizeButtons.get(i).show();
        if(changeSizeButtons.get(i).inButton()==true) changeSizeButtons.get(i).highlighted();
        else  changeSizeButtons.get(i).nonHighlighted();
    }  
}

public boolean isWon()
{
    int numberOfClickedThings = 0;

    for(int c = 0; c<NUM_COLS; c++)
        for(int r = 0; r<NUM_ROWS; r++)
            if(!bombs.contains(buttons[r][c]) && buttons[r][c].isClicked()==true)
                numberOfClickedThings ++;

    if(numberOfClickedThings == NUM_NON_BOMS)  return true;
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

        if(mouseButton == RIGHT)
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
        textSize(30);
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this)) 
        {
            fill(255,0,0);
            rect(x, y, width, height);          
            fill(200);
            image(webImg, x + width/2+3, y+ height/2, width, height);
        }
        else if(clicked)
        {
            fill( 200 ); 
            rect(x, y, width, height);
        }
        else if(win)
        {
            fill(0,255,0);
            rect(x, y, width, height);
        }
        else if(lose)
        {
            fill(0,0,255);
            rect(x, y, width, height);
        }
        else 
        {
            fill(100);
            rect(x, y, width, height);
        }

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

public class Button
{
  private int myX, myY, myColor, widthh, heightt;
  private String myType;

  Button(int x, int y, String type)
  {
    myX = x;
    myY = y;
    myType = type;
    myColor = 255;
    widthh = 40;
    heightt = 40;
  }

  public void show()
  {
    //noStroke();
    fill(myColor);
    rect(myX, myY, widthh,heightt, 10);
    fill(255,0,0);
    textSize(30);

    if(myType == "boxSizePlus")
    {
        text("+", myX+widthh/2, myY + heightt/2-5);
    }
    else if(myType == "boxSizeMinus")
    {
        text("-", myX+widthh/2, myY + heightt/2-5);
    }
    else if(myType == "numBoxesPlus")
    {
        text("+", myX+widthh/2, myY + heightt/2-5);
    }
    else if(myType == "numBoxesMinus")
    {
        text("-", myX+widthh/2, myY + heightt/2-5);
    }
  }
  
  public void highlighted()
  {
    myColor = color(250,237,150);      
  }   
  public void nonHighlighted()
  {
    myColor = 255;
  }

  public boolean inButton()
  {
    if(mouseX > myX && mouseX < myX+widthh && mouseY > myY && mouseY < myY+heightt)
        return true;
    return false;
  }
}

public class GameRestart
{
  int myColor;

  GameRestart()
  {
    myColor = color(224, 74, 69);
  }

  void show()
  {
    fill(myColor);
    rect(200, 400, 200, 70,10);
    fill(255);
    textSize(30);
    text("Restart", 245,445);
  }

  void nonHighlighted()
  {
    myColor = color(224, 74, 69);
  }

  void highlighted()
  {
    myColor = color(242, 40, 33);
  }
}

































