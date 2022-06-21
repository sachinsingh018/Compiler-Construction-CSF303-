#include<stdio.h>
int main()
{
	int i;
	int n;
	int sum;
	int e;
	int j;
	sum=0;
	i=1;
	n=10;
	e=2;
	while(!(i>n))	
	{
		j=i%2;
		(j==0)?{sum=sum+e^j;}:{;}
		i++;
	}

}
