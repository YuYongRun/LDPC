# LDPC
LDPC error rate simulation using MATLAB, with multi-functions.
1.	Exact BP decoder, including flooding and layered schedules.
2.	Optional modulation schemes, including BPSK, 4ASK, 8ASK, 16ASK, QPSK, 16QAM, 64QAM, and 256QAM. The bit label is Gray labeling, simply mapping the coded bits x1, x2, …, x_m to the first symbol, x_{m+1}, x_{m+2}, …, x_{2m} to the second symbol, and so on. The demodulation scheme is in the BICM-style, which ignores the dependence in each bit label. 
3.	Many kinds of LDPC codes, including EG-LDPC, PG-LDPC, 802.11n-LDPC, 802.16e-LDPC, PEG/ACE-LDPC. Mackay LDPC and several PEG-LDPC can be downloaded from http://www.inference.org.uk/mackay/codes/data.html#l66. Besides, I also write a PEG/ACE construction algorithm.
4.	I use x = uG = u [I P] to encode, because this is a general method, valid for ALL kinds of codes. Parity-check matrix P is simply extracted from the sparse matrix H by Gaussian elimination.
5.	Are you interested in counting the cycles in the H matrix? Well, I write programs to count the number of the length-6, 8, and 10 cycles in the H matrix. 
6.	You can see the PDF file for BLER performance comparisons between all kinds of LDPC codes and polar codes of length 2000 and rate 0.5 in the BPSK-AWGN channel.
7. Several methods for predicting the ensemble decoding threshold in BPSK-AWGN channel are provided, i.e., EXIT charts and Gaussian Approximation. 

I am just a new learner for LDPC codes, reading just preliminary paper and textbook. If you find any problems in my codes, please contact me 498699845@qq.com
