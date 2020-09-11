# SimpleQueue

iex -S mix

import SimpleQueue.SimpleQueueSupervisor

SimpleQueue.SimpleQueueSupervisor.start_children
SimpleQueue.SimpleQueueSupervisor.stop_child

SimpleQueue.SimpleQueueSupervisor.start_child(:test1)
SimpleQueue.SimpleQueueSupervisor.start_child(:test2)

SimpleQueueSupervisor.count_children(SimpleQueue.SimpleQueueSupervisor)

SimpleQueue.SimpleQueueSupervisor.find_child(:test1)
SimpleQueue.SimpleQueueSupervisor.remove_child(SimpleQueue.SimpleQueueSupervisor.find_child(:test1))
SimpleQueue.SimpleQueueSupervisor.delete_child(SimpleQueue.SimpleQueueSupervisor.find_child(:test1))
SimpleQueue.SimpleQueueSupervisor.children
SimpleQueue.SimpleQueueSupervisor.count_children

DynamicSupervisor.count_children(SimpleQueue.SimpleQueueSupervisor)
DynamicSupervisor.stop(SimpleQueue.SimpleQueueSupervisor)


