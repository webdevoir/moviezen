export default function formatDate(dateStr) {
  let date = new Date(dateStr)
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ]
  return `${
    monthNames[date.getMonth()]
  } ${date.getDay()}, ${date.getFullYear()}`
}
