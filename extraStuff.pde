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
        fill(myColor);
        rect(myX, myY, widthh, heightt, 10);
        fill(255,0,0);
        textSize(30);

        if(myType == "restart")
            text("Restart", myX+widthh/2, myY);

        /*
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
        */
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

/*
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
*/


/*
ArrayList<Confetti> confetti = new ArrayList<Confetti>();

void setup()
{
  size(1000,700);
  for(int i = 0; i<100; i++)
    confetti.add(new Confetti());
}
void draw()
{
  background(0);
  for(Confetti con : confetti)
  {
    con.move();
    con.show();
  }
}
*/

public class Confetti
{
    int myX, myY, myColor, mySpeed, originalX, originalY;
    float myAngle;

    Confetti()
    {
        myX = height + (int)(Math.random()*(width-height));
        myY = -(int)(Math.random()*height);
        originalX = myX;
        originalY = myY;
        mySpeed = (int)(Math.random()*5)+6;
        double randomm = Math.random();
        if(randomm < 0.33)
            myColor = color(255,0,0);
        else if(randomm < 0.66)
            myColor = color(0,102,0);
        else
            myColor = color(0,0,255);

        myAngle = (float)(Math.random()*2*PI/3+PI/6);
    }

    void show()
    {
        stroke(0);
        fill(myColor);
        rect(myX, myY, 10, 20,10);
    }

    void move()
    {
        myX += (int)(cos(myAngle)*mySpeed);
        myY += (int)(sin(myAngle)*mySpeed);
        if(myY > height || myX < height || myX > width)
        {
          myY = originalY;
          myX = originalX;
          mySpeed = (int)(Math.random()*5)+6;
        }
    }
}



public void gameRunning()
{
    //in future: make button for different size playing field
}











