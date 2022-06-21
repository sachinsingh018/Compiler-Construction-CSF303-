#include<stdio.h>
int main()
{
	int i;
	int n;
	int sum;
	int j;
	sum=0;
	n=10;
	for(i=1;i<=n;i++)
	{
		j=i%2;
		int e;
		e=2;
		if(j==0)
		{
			sum=sum+e^j;
		}
	}

}
