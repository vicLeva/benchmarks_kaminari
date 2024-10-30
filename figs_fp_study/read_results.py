import pathlib
import matplotlib.pyplot as plt

pwd = str(pathlib.Path(__file__).parent.resolve())

n_files = 25

expes = [("/res_queries_r1.txt", 50000, [0]*n_files, [0]*n_files, 1.0), ("/res_queries_r08.txt", 25000, [0]*n_files, [0]*n_files, 0.8),
         ("/res_queries_r06.txt", 5000, [0]*n_files, [0]*n_files, 0.6), ("/res_queries_r04.txt", 1000, [0]*n_files, [0]*n_files, 0.4), 
         ("/res_queries_r02.txt", 100, [0]*n_files, [0]*n_files, 0.2)]


for exp in expes:
    with open(pwd+exp[0], "r") as fp:
        for i in range(n_files):
            total_fp = 0
            total_fp_list = 0

            for j in range(exp[1]):
                next(fp)
                line = next(fp)
                list = eval(line.strip())

                total_fp += len(list)
                if len(list) > 0:
                    total_fp_list += 1 

            avg = total_fp/total_fp_list if total_fp_list > 0 else 0
            exp[2][i] = [total_fp_list/exp[1], avg] 
            # nb de lists avec au moins 1 fp sur le nb total de lists pour une taille de query seq donnée 
            # nb moyen d'id fp par list contenant des fp



with open(pwd+"/times.txt", "r") as fp:
    for i in range(len(expes)):
        for j in range(n_files):
            line = next(fp)
            time = int(line.rstrip().split(" ")[-1][:-2])
            expes[i][3][j] = time


query_sizes = [i for i in range(50, 1050, 50)]
for i in [90, 80, 70, 60]:
    query_sizes.insert(1, i)
query_sizes.append(5000)

configurations = ['r = 1.0', 'r = 0.8', 'r = 0.6', 'r = 0.4', 'r = 0.2']

""" TIMES """
plt.figure(figsize=(12, 8))
for exp in expes:
    plt.plot(query_sizes[:-1], [time/exp[1] for time in exp[3][:-1]], marker='o', label=f"r = {str(exp[4])}")

plt.title('Time')
plt.xlabel('Query length')
plt.ylabel('Query speed (ms/query)')
plt.legend()
plt.grid(True)
plt.show()


""" FPs """
plt.figure(figsize=(12, 8))
for exp in expes:
    plt.plot(query_sizes[:-1], [tmp[0] for tmp in exp[2][:-1]], marker='o', label=f"r = {str(exp[4])}")
    print(exp[2][0])

plt.title('FP rate (nb_answers w/ atleast 1 FP over total answers)')
plt.xlabel('Query length')
plt.ylabel('FP rate')
plt.legend()
plt.grid(True)
plt.show()


""" AVG """
plt.figure(figsize=(12, 8))
for exp in expes:
    plt.plot(query_sizes[:-1], [tmp[1] for tmp in exp[2][:-1]], marker='o', label=f"r = {str(exp[4])}")
    print(exp[2][1])

plt.title('Average number of FP in lists containing FPs')
plt.xlabel('Query length')
plt.ylabel('Average')
plt.legend()
plt.grid(True)
plt.show()