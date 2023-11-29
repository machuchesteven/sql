counters = "1,1,1,,,2"


counters_list = counters.split(",")
print(counters_list)

counter = list(set(counters_list))

if counter.index("") >= 0:
    print(counter.index(""))
    counter.remove("")
    print(counter)
    counter.sort()

print(counter)
print("counter_list: ", counter)