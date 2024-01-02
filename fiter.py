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


counter_items = ""
for item in counter:
    counter_items += f"{item},"
print(counter_items[:-1])
