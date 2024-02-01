from azure.servicebus import ServiceBusClient, ServiceBusMessage
from azure.identity.aio import DefaultAzureCredential

credential = DefaultAzureCredential()

def main():
    try:
        src_connection_string = "<REPLACE-WITH-AZURE-SERVICE-BUS-STANDARD-CONNECTION-STRING>"
        dest_connection_string = "<REPLACE-WITH-AZURE-SERVICE-BUS-PREMIUM-CONNECTION-STRING>"
        src_queue_name = "queue-test"
        dest_queue_name = "queue-test"

        with ServiceBusClient.from_connection_string(src_connection_string) as src_client, \
             ServiceBusClient.from_connection_string(dest_connection_string) as dest_client:

            src_queue = src_client.get_queue_receiver(queue_name=src_queue_name)
            dest_queue = dest_client.get_queue_sender(queue_name=dest_queue_name)

            with src_queue, dest_queue:
                while True:
                    messages = src_queue.receive_messages(max_message_count=1, max_wait_time=5)
                    if messages:
                        dest_queue.send_messages(messages)
                        print("Message Read successfully!")
                    else:
                        print("No more messages")
                        break

    except Exception as ex:
        print(str(ex))
        raise

if __name__ == "__main__":
    main()
