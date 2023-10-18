#include "mex.h"

#define MIN(a,b) (a<b)?a:b

void tarjan(int *DFN, int *LOW, int *Ncom, int *stccom, int *stack, int *isstack, int *num, int *top, int *label, int *I, int *C, int m, int n)
{
    int i,j,w;
    
	DFN[label[0]-1]=num[0];
	LOW[label[0]-1]=num[0];
	num[0]=num[0]+1;
	top[0]=top[0]+1;
	stack[top[0]-1]=label[0];//放入栈中
	isstack[label[0]-1]=1;//放入栈中
	
	for(i=0;i<I[label[0]-1];i++)
	{
		w=C[i*m+label[0]-1];
		if((DFN[w-1])==0)
		{
			tarjan(DFN,LOW,Ncom,stccom,stack,isstack,num,top,&w,I,C,m,n);
		    LOW[label[0]-1]=MIN(LOW[label[0]-1],LOW[w-1]);
		}
		else if(DFN[w-1]<DFN[label[0]-1])
			if(isstack[w-1]==1)
				LOW[label[0]-1]=MIN(LOW[label[0]-1],DFN[w-1]);
	}

	if(LOW[label[0]-1]==DFN[label[0]-1])
	{
		Ncom[0]=Ncom[0]+1;
		while(1)
		{
			j=stack[top[0]-1];
			stccom[j-1]=Ncom[0];
			stack[top[0]-1]=0;
			isstack[j-1]=0;
			top[0]=top[0]-1;
			if(j==label[0]||top[0]<=0)
				break;
		}
	}
}

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    int *DFN, *LOW, *Ncom, *stccom, *stack, *isstack, *num, *top, *label, *I, *C;
    int i,m,n;

    if(nrhs!=11)
        mexErrMsgTxt("Input Error!\n");

    DFN=(int *) mxGetPr(prhs[0]);
    LOW=(int *) mxGetPr(prhs[1]);
    Ncom=(int *) mxGetPr(prhs[2]);
    stccom=(int *) mxGetPr(prhs[3]);
    stack=(int *) mxGetPr(prhs[4]);
    isstack=(int *) mxGetPr(prhs[5]);
    num=(int *) mxGetPr(prhs[6]);
    top=(int *) mxGetPr(prhs[7]);
    label=(int *) mxGetPr(prhs[8]);
    I=(int *) mxGetPr(prhs[9]);
    C=(int *) mxGetPr(prhs[10]);

	m=(int) mxGetM(prhs[10]);//矩阵C的行列数目
	n=(int) mxGetN(prhs[10]);

	tarjan(DFN,LOW,Ncom,stccom,stack,isstack,num,top,label,I,C,m,n);

    if(nlhs!=8)
        mexErrMsgTxt("Output Error!\n");

    plhs[0]=prhs[0];
    plhs[1]=prhs[1];
    plhs[2]=prhs[2];
    plhs[3]=prhs[3];
    plhs[4]=prhs[4];
    plhs[5]=prhs[5];
    plhs[6]=prhs[6];
    plhs[7]=prhs[7];

}


