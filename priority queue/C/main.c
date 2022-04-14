
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

struct node
{
    int data;
    struct node* left;
    struct node* right;
};
typedef struct node node;
int last_item = 0; //index of last item
int parent(int i);
int left_child(int i);
int right_child(int i);
node *create_node(int value);
void heapify(int* ptr, int last_element_index);
void insert(int var, int *ptr);
void swap(int *ptr1 , int *ptr2);
int height(node* node);
void current(node* node,int l);
void printlvl(node* node);
int *create_array(int size);
node *convert(node* node,int *ptr,int start_index,int last_index);


int *create_array(int size)
{
    return (int*) malloc(size*sizeof(int));
}
node *convert(node* node,int *ptr,int start_index,int last_index)
{
    if(start_index<last_index)
    {
        struct node *t = create_node(*(ptr + start_index));
        node = t;
        node->right = convert(node->right,ptr, right_child(start_index),last_index);
        node->left = convert(node->left,ptr, left_child(start_index),last_index);


    }
    return node;
}
node *create_node(int value)
{
    node *result = (node*) malloc(sizeof(node));
    if (result!=NULL)
    {
        result->left = NULL;
        result->right = NULL;
        result->data = value;
        return result;
    }
    return NULL;
}
int parent(int i)
{
    return (i-1)/2;
}
int left_child(int i)
{
    return (2*i)+1;
}
int right_child(int i)
{
    return (2*i)+2;
}
void insert(int var, int *ptr)
{
    if (ptr == NULL)
    {
        printf("Array pointer is NULL\n");
    }
    else {
        *(ptr + last_item) = var;
        heapify(ptr, last_item);
        last_item += 1;
    }
}
void swap(int *ptr1 , int *ptr2)
{
    int temp;
    temp = *ptr1;
    *ptr1 = *ptr2;
    *ptr2 = temp;
}
void heapify(int* ptr, int last_element_index)
{
    if ((void *) *ptr == NULL)
    {
        printf("Heap is Empty");
    }
    else
    {
        int item_index=last_element_index;
        int *t=ptr+item_index;
        while ((t)>ptr &&
               *(ptr+parent(item_index))<*(t))
        {
            swap(ptr+parent(item_index),t);
            t = ptr + parent(item_index);
            item_index = parent(item_index);
        }
    }
}
int height(node* node)
{
    if (node==NULL){return 0;}
    else
    {
        int left = height(node->left);
        int right = height(node->right);

        if(left>right){return left+1;}
        else{return right+1;}
    }
}
void current(node* node,int l)
{
    if (node==NULL){return;}
    if (l==1){ printf("%d ",node->data);}
    else if (l>1)
    {
        current(node->left,l-1);
        current(node->right,l-1);
    }
}
void printlvl(node* node)
{
    int h = height(node);
    int i;
    for (i = 1; i <= h; i++) {
        current(node,i);
    }
}

void simple_test()
{
    printf("***********Simple Test Scenario *************\n");
    int test_arr[] = {21, 15, 45, 78, 95, 2, 14, 65, 75, 10, 68, 42, 7, 1, 19, 99, 45, 74, 39, 40};
    int *test_arr1 = NULL;
    test_arr1 = (int *) malloc(20 * sizeof(int));
    printf("Original Array : ");
    for (int i = 0; i < 20; ++i) {
        printf("%d ",test_arr[i]);
    }
    clock_t start,end;
    start = clock();
    for (int i = 0; i < 20; i++)
    {
        insert(test_arr[i], test_arr1);
    }
    end = clock();
    printf("\nExecution time of Simple Test is : %f \n",(double)(end-start)/CLOCKS_PER_SEC);
    printf("\nPriority Queue (ARRAY) : ");
    for (int i = 0; i < 20; i++)
    {
        printf("%d ",*(test_arr1+i));
    }
    struct node *root = NULL;
    root = convert(root,test_arr1,0, 20);
    printf("\nPriority Queue (STRUCTURE) : ");
    printlvl(root);
    free(root);
    free(test_arr1);
}

int main(){

//    FILE *filepointer = NULL;
//    filepointer = fopen("test.txt", "r");
//
//    clock_t start,stop;
//
//    int *arr = NULL;
//    arr = create_array(67108864);
//
//    int tmp;
//    for (int j=0;j<67108864;j++) //2^26
//    {
//        fscanf(filepointer, "%d", &tmp);
//        *(arr+j) = tmp;
//    }
//    fclose(filepointer);
//
//    start=clock();
//    int *test = NULL;
//    test= create_array(67108864); //2^26 item
//    for (int i = 0; i < 67108864; ++i) {
//        insert(*(arr+i),test);
//    }
//    stop = clock();
//    printf("Execution time for 2^26 integer value is :  %f\n",(double)(stop-start)/CLOCKS_PER_SEC);
//
//    free(arr);
//    printf("_____________________________________________\n");
//
//
//    node *node = NULL;
//    node = convert(node,test,0,last_item);
//
//
//    last_item = 0;
//
//    filepointer=NULL;
//    filepointer= fopen("test_result","w");
//    for (int i = 0; i < 67108864; ++i) {
//        fprintf(filepointer,"%d ",*(test+i));
//    }
//    fclose(filepointer);
//    free(node);
//    free(test);
    last_item = 0;
    simple_test();

}
main();